/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.datamanager;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataSource;
import com.google.android.gms.fitness.data.DataType;
import com.google.android.gms.fitness.data.DataTypes;
import com.google.android.gms.fitness.request.DataDeleteRequest;
import com.google.android.gms.fitness.request.DataInsertRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * Provides the capability to inject (and delete) demo data into the user's Google Fit account.
 * This is useful for demoing purposes when actual data is absent. This class is dependent on
 * the file healthData.json found in the assets directory.
 */
public class HealthDataInjector {
    private static final String TAG = HealthDataInjector.class.getSimpleName();
    private static final float KILO_TO_LBS = 2.20462f;

    private Context mContext;
    private GoogleApiClient mClient;
    private DataNotifier mNotifier;

    private long timeNow = new Date().getTime();

    /**
     *
     * @param context The context where the data injection is being used (should be an Activity)
     * @param client An instance of the GoogleApiClient (refer to HealthDataRetriever#getClient())
     * @param notifier The instance that should be notified when the operation has finished
     */
    public HealthDataInjector(Context context, GoogleApiClient client, DataNotifier notifier) {
        mContext = context;
        mClient = client;
        mNotifier = notifier;
    }

    /**
     * This will inject the demo data found in healthData.json into the user's Google Fit account.
     * This can take a few minutes to complete. When completed, the DataNotifier passed to the
     * constructor will be invoked.
     */
    public void inject() {
        new InsertDataTask().execute();
    }

    /**
     * This will delete any demo data that was previously injected into the user's Google Fit
     * account. This operation is typically much faster than data injection and should only take
     * a second or two on most devices. When completed, the DataNotifier passed to the constructor
     * will be invoked.
     */
    public void delete() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        long endTime = calendar.getTimeInMillis();
        calendar.add(Calendar.YEAR, -10); // cover a generous 10 year span
        long startTime = calendar.getTimeInMillis();

        DataDeleteRequest request = new DataDeleteRequest.Builder()
                .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                .addDataType(DataTypes.CALORIES_EXPENDED)
                .addDataType(DataTypes.HEART_RATE_BPM)
                .addDataType(DataTypes.STEP_COUNT_DELTA)
                .addDataType(DataTypes.WEIGHT)
                .build();

        Fitness.HistoryApi.deleteData(mClient, request)
                .setResultCallback(new ResultCallback<Status>() {
                    @Override
                    public void onResult(Status status) {
                        mNotifier.dataIsAvailable();
                    }
                });
    }

    private class InsertDataTask extends AsyncTask<Void, Void, Void> {
        @Override
        protected Void doInBackground(Void... params) {
            try {
                String json = getJSONDemoData();
                JSONObject metricsObject = new JSONObject(json).getJSONObject("Metrics");

                Log.i(TAG, "Injecting Calories data...");
                injectData(metricsObject, HealthDataRetriever.DataType.CALORIES);
                Log.i(TAG, "Calories data successfully injected!");

                Log.i(TAG, "Injecting Heart Rate data...");
                injectData(metricsObject, HealthDataRetriever.DataType.HEART_RATE);
                Log.i(TAG, "Heart Rate data successfully injected!");

                Log.i(TAG, "Injecting Steps data...");
                injectData(metricsObject, HealthDataRetriever.DataType.STEPS);
                Log.i(TAG, "Steps data successfully injected!");

                Log.i(TAG, "Injecting Weight data...");
                injectData(metricsObject, HealthDataRetriever.DataType.WEIGHT);
                Log.i(TAG, "Weight data successfully injected!");
            } catch (JSONException e) {
                e.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            mNotifier.dataIsAvailable();
        }
    }

    private void injectData(JSONObject metricsObject, HealthDataRetriever.DataType type)
            throws JSONException {

        String jsonName;
        DataType dataType;
        switch (type) {
            case CALORIES:
                jsonName = "Calories";
                dataType = DataTypes.CALORIES_EXPENDED;
                break;
            case HEART_RATE:
                jsonName = "HeartRate";
                dataType = DataTypes.HEART_RATE_BPM;
                break;
            case STEPS:
                jsonName = "Steps";
                dataType = DataTypes.STEP_COUNT_DELTA;
                break;
            case WEIGHT:
                jsonName = "BodyWeight";
                dataType = DataTypes.WEIGHT;
                break;
            default:
                return;
        }

        // iterate through each JSON object of the specified metric type
        JSONArray array = metricsObject.getJSONArray(jsonName);
        for (int i = 0; i < array.length(); i++) {
            JSONObject object = array.getJSONObject(i);

            int value = object.getInt("value");
            long timeStamp = timeNow - object.getLong("timeDiff");

            if (dataType == DataTypes.WEIGHT) {
                value = Math.round(value / KILO_TO_LBS);
            }

            DataSource dataSource = new DataSource.Builder()
                    .setAppPackageName(mContext.getApplicationContext())
                    .setDataType(dataType)
                    .setName("Simulated Data")
                    .setType(DataSource.TYPE_RAW)
                    .build();

            DataSet dataSet = DataSet.create(dataSource);

            if (dataType == DataTypes.STEP_COUNT_DELTA) {
                dataSet.add(dataSet.createDataPoint()
                        .setTimeInterval(timeStamp - 10000, timeStamp, TimeUnit.MILLISECONDS)
                        .setIntValues(value));
            } else {
                dataSet.add(dataSet.createDataPoint()
                        .setTimestamp(timeStamp, TimeUnit.MILLISECONDS)
                        .setFloatValues((float) value));
            }

            DataInsertRequest request = new DataInsertRequest.Builder()
                    .setDataSet(dataSet)
                    .build();

            Fitness.HistoryApi.insert(mClient, request).await(1, TimeUnit.MINUTES);
        }
    }

    private String getJSONDemoData() {
        try {
            InputStream stream = mContext.getAssets().open("healthData.json");
            int size = stream.available();
            byte[] buffer = new byte[size];
            int resultSize = stream.read(buffer);
            if (resultSize != size) {
                Log.i(TAG, "Not all of healthData.json was read.");
            }
            stream.close();
            return new String(buffer);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

}
