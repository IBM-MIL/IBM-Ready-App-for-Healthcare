/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.datamanager;

import android.app.Activity;
import android.content.Context;
import android.content.IntentSender;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.fitness.Fitness;
import com.google.android.gms.fitness.FitnessScopes;
import com.google.android.gms.fitness.data.AggregateDataTypes;
import com.google.android.gms.fitness.data.Bucket;
import com.google.android.gms.fitness.data.DataPoint;
import com.google.android.gms.fitness.data.DataSet;
import com.google.android.gms.fitness.data.DataTypes;
import com.google.android.gms.fitness.data.Field;
import com.google.android.gms.fitness.request.DataReadRequest;
import com.google.android.gms.fitness.result.DataReadResult;
import com.ibm.mil.readyapps.physio.utils.UnitLocale;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Used to retrieve a user's Google Fit data for population within the Physio app. Allows the
 * client to specify start and end dates, number of intervals over time, unit of time, and the type
 * of health data to be retrieved. Note that retrieval of calories data for a high number of
 * intervals is a time-expensive operation due to limitations with the Google Fit API.
 */
public class HealthDataRetriever {
    private static final String TAG = HealthDataRetriever.class.getSimpleName();

    private final Date mStartDate;
    private final Date mEndDate;
    private final TimeUnit mTimeUnit;
    private final int mTimeInterval;
    private final DataType mDataType;
    private final UnitLocale mUnitLocale;
    private final Handler mHandler;

    /**
     * After building the desired HealthDataRetriever object, call its retrieve() method to
     * invoke the operation for collecting the user's desired data from Google Fit. This is an
     * asynchronous operation and may take a few seconds to complete in some cases. The Handler
     * set in the Builder will be notified when the operation has completed.
     *
     * @param client an instance of a GoogleApiClient (refer to getClient())
     */
    public void retrieve(final GoogleApiClient client) {
        client.registerConnectionCallbacks(new GoogleApiClient.ConnectionCallbacks() {
            @Override
            public void onConnected(Bundle bundle) {
                new HealthAsyncTask(client, this).execute();
            }

            @Override
            public void onConnectionSuspended(int i) {
                if (i == GoogleApiClient.ConnectionCallbacks.CAUSE_NETWORK_LOST) {
                    Log.i(TAG, "Connection lost.  Cause: Network Lost.");
                } else if (i == GoogleApiClient.ConnectionCallbacks.CAUSE_SERVICE_DISCONNECTED) {
                    Log.i(TAG, "Connection lost.  Reason: Service Disconnected");
                }
            }
        });
    }

    /**
     * Use the HealthDataRetriever's Builder class to build the desired HealthDataRetriever object
     * for retrieving the Google Fit data. While all fields used by the HealthDataRetriever have
     * a default implementation provided by the Builder, in most cases it is useful to set them
     * all manually. Calls for setting fields may be chained and calling build() will return an
     * instance of HealthDataRetriever with the desired fields set.
     */
    public static class Builder {
        private Date startDate = new Date();
        private Date endDate = new Date();
        private TimeUnit timeUnit = TimeUnit.DAYS;
        private int timeInterval = 1;
        private DataType dataType = DataType.STEPS;
        private UnitLocale unitLocale = UnitLocale.getDefault();
        private Handler handler = new Handler() {
            @Override
            public void handle(List<Integer> data) {
                // default implementation
            }
        };

        /**
         * @param start The start date for collecting data (should proceed endDate)
         * @return The Builder instance being constructed
         */
        public Builder startDate(Date start) {
            startDate = start;
            return this;
        }

        /**
         * @param end The end date for collecting data (should succeed startDate)
         * @return The build instance being constructed
         */
        public Builder endDate(Date end) {
            endDate = end;
            return this;
        }

        /**
         * @param unit The unit of time for collecting data over the timeInterval
         * @return The build instance being constructed
         */
        public Builder timeUnit(TimeUnit unit) {
            timeUnit = unit;
            return this;
        }

        /**
         * @param interval The number of intervals to collect data over the desired time span
         *                 (endDate - startDate) in the specified unit of time (timeUnit). This
         *                 corresponds to the number of data points returned to the handler.
         * @return The build instance being constructed.
         */
        public Builder timeInterval(int interval) {
            timeInterval = interval;
            return this;
        }

        /**
         * @param type The type of data to be collected from Google Fit
         * @return The build instance being constructed
         */
        public Builder dataType(DataType type) {
            this.dataType = type;
            return this;
        }

        /**
         * @param locale The system of measurement for the collected data from GoogleFit
         * @return The build instance being constructed
         */
        public Builder unitLocale(UnitLocale locale) {
            this.unitLocale = locale;
            return this;
        }

        /**
         * @param handler The handler that will receive the collection of data points once the
         *                data collection operation has finished.
         * @return The build instance being constructed
         */
        public Builder handler(Handler handler) {
            this.handler = handler;
            return this;
        }

        /**
         * @return An instance of HealthDataRetriever with the desired fields set by the builder
         */
        public HealthDataRetriever build() {
            return new HealthDataRetriever(this);
        }
    }

    // non-instantiable from outside of the class, only accessible through Builder#build()
    private HealthDataRetriever(Builder builder) {
        mStartDate = builder.startDate;
        mEndDate = builder.endDate;
        mTimeUnit = builder.timeUnit;
        mTimeInterval = builder.timeInterval;
        mDataType = builder.dataType;
        mUnitLocale = builder.unitLocale;
        mHandler = builder.handler;
    }

    /**
     * Used by HealthDataRetriever to return the collected data points from Google Fit. Since the
     * data collection operation is asynchronous, the handle() method will be called sometime after
     * the original call to retrieve(). Set the handler with the Builder class.
     */
    public interface Handler {
        void handle(List<Integer> data);
    }

    /**
     * The specific data types that HealthDataRetriever is built to collect from Google Fit. Set
     * the desired DataType with the Builder class.
     */
    public enum DataType {
        CALORIES, HEART_RATE, PAIN, STEPS, WEIGHT
    }

    // The asynchronous task for collecting data from Google Fit
    private class HealthAsyncTask extends AsyncTask<Void, Void, List<Integer>> {
        private static final float KILO_TO_LBS = 2.2046f;
        private static final float KCAL_TO_JOULES = 4.184f;
        private GoogleApiClient client;
        private GoogleApiClient.ConnectionCallbacks callbacks;

        HealthAsyncTask(GoogleApiClient client, GoogleApiClient.ConnectionCallbacks callbacks) {
            super();
            this.client = client;
            this.callbacks = callbacks;
        }

        @Override
        protected List<Integer> doInBackground(Void... params) {
            // All builders will use the same time span
            DataReadRequest.Builder builder = new DataReadRequest.Builder()
                    .setTimeRange(mStartDate.getTime(), mEndDate.getTime());

            // customize the builder based on the desired data type
            switch (mDataType) {
                case CALORIES:
                    // calories can't be bucketed unfortunately
                    builder = builder.read(DataTypes.CALORIES_EXPENDED);
                    break;
                case HEART_RATE:
                    builder = builder
                            .aggregate(DataTypes.HEART_RATE_BPM, AggregateDataTypes.HEART_RATE_SUMMARY)
                            .bucketByTime(mTimeInterval, mTimeUnit);
                    break;
                case STEPS:
                    builder = builder
                            .aggregate(DataTypes.STEP_COUNT_DELTA, AggregateDataTypes.STEP_COUNT_DELTA)
                            .bucketByTime(mTimeInterval, mTimeUnit);
                    break;
                case WEIGHT:
                    builder = builder
                            .aggregate(DataTypes.WEIGHT, AggregateDataTypes.WEIGHT_SUMMARY)
                            .bucketByTime(mTimeInterval, mTimeUnit);
                    break;
            }

            // get the raw data from Google Fit
            DataReadResult result = Fitness.HistoryApi.readData(client, builder.build())
                    .await(1, TimeUnit.MINUTES);

            // calories can't be bucketed
            if (mDataType == DataType.CALORIES) {
                result.getBuckets().add(null);
            }

            // go through each bucket of raw data, collecting it into data points
            List<Integer> data = new ArrayList<>();
            for (Bucket bucket : result.getBuckets()) {
                List<DataSet> dataSets = mDataType == DataType.CALORIES ? result.getDataSets() : bucket.getDataSets();
                for (DataSet dataSet : dataSets) {
                    float dataPointSum = 0;
                    int count = 0;
                    for (DataPoint dp : dataSet.getDataPoints()) {
                        for (Field field : dp.getDataType().getFields()) {
                            if (mDataType == DataType.STEPS) {
                                // raw steps data are integers
                                dataPointSum += dp.getValue(field).asInt();
                            } else if (mDataType == DataType.WEIGHT &&
                                    mUnitLocale == UnitLocale.Imperial) {
                                // convert unit of measurement from kilo's to lbs
                                dataPointSum += dp.getValue(field).asFloat() * KILO_TO_LBS;
                            } else if (mDataType == DataType.CALORIES &&
                                    mUnitLocale == UnitLocale.Metric) {
                                // convert unit of measurement from calories to joules
                                dataPointSum += dp.getValue(field).asFloat() * KCAL_TO_JOULES;
                            } else {
                                // all other raw data are floats
                                dataPointSum += dp.getValue(field).asFloat();
                            }
                            count++;
                        }
                    }

                    if (mDataType == DataType.HEART_RATE || mDataType == DataType.WEIGHT) {
                        // get the average for heart rate and weight data points
                        int average = count != 0 ? (int) dataPointSum / count : 0;
                        data.add(average);
                    } else {
                        // sum for calories and steps data points
                        data.add((int) dataPointSum);
                    }
                }
            }

            return data;
        }

        @Override
        protected void onPostExecute(List<Integer> result) {
            mHandler.handle(result); // return the collected data to the handler
            client.unregisterConnectionCallbacks(callbacks);
        }

    }

    private static GoogleApiClient client;
    private static Context clientContext;
    public static boolean authInProgress = false;
    public static final int REQUEST_OAUTH = 1;

    /**
     * Returns a cached GoogleApiClient. This is used to authenticate the user in order to access
     * their Google Fit data. Note, if the context that's passed to getClient() changes, then
     * a new client will be constructed.
     *
     * @param context The context where the user should be authenticated for accessing their
     *                Google Fit data
     * @return An instance of GoogleApiClient for the authenticated user in the given context
     */
    public static GoogleApiClient getClient(Context context) {
        if (client == null || clientContext != context) {
            clientContext = context;
            client = new GoogleApiClient.Builder(clientContext)
                    .addApi(Fitness.API)
                    .addScope(FitnessScopes.SCOPE_ACTIVITY_READ_WRITE)
                    .addScope(FitnessScopes.SCOPE_BODY_READ_WRITE)
                    .addConnectionCallbacks(
                            new GoogleApiClient.ConnectionCallbacks() {
                                @Override
                                public void onConnected(Bundle bundle) {
                                    Log.i(TAG, "Connected to GoogleApiClient");
                                }

                                @Override
                                public void onConnectionSuspended(int i) {
                                    if (i == GoogleApiClient.ConnectionCallbacks.CAUSE_NETWORK_LOST) {
                                        Log.i(TAG, "Connection lost. Cause: Network Lost.");
                                    } else if (i == GoogleApiClient.ConnectionCallbacks
                                            .CAUSE_SERVICE_DISCONNECTED) {
                                        Log.i(TAG, "Connection lost. Cause: Service Disconnected");
                                    } else {
                                        Log.i(TAG, "Connection lost. Cause: Undetermined.");
                                    }
                                }
                            }
                    )
                    .addOnConnectionFailedListener(
                            new GoogleApiClient.OnConnectionFailedListener() {
                                @Override
                                public void onConnectionFailed(ConnectionResult result) {
                                    Log.i(TAG, "Connection failed. Cause: " + result);
                                    if (!result.hasResolution()) {
                                        GooglePlayServicesUtil.getErrorDialog(
                                                result.getErrorCode(),
                                                (Activity) clientContext,
                                                0).show();
                                        return;
                                    }
                                    if (!authInProgress) {
                                        try {
                                            Log.i(TAG, "Attempting to resolve failed connection");
                                            authInProgress = true;
                                            result.startResolutionForResult(
                                                    (Activity) clientContext,
                                                    REQUEST_OAUTH);
                                        } catch (IntentSender.SendIntentException e) {
                                            Log.e(TAG,
                                                    "Exception while starting resolution activity",
                                                    e);
                                        }
                                    }
                                }
                            }
                    )
                    .build();
        }

        return client;
    }

}
