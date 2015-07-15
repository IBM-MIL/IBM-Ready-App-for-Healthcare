/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.fragments;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.api.GoogleApiClient;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataRetriever;
import com.ibm.mil.readyapps.physio.models.PainReport;
import com.ibm.mil.readyapps.webview.MILWebView;
import com.ibm.mil.readyapps.webview.OnPageChangeListener;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import io.realm.Realm;
import io.realm.RealmResults;

public class ProgressFragment extends Fragment implements OnPageChangeListener {
    private static final String TAG = ProgressFragment.class.getSimpleName();

    private String launchUrl;
    private String route;
    private MILWebView mWebView;
    private GoogleApiClient mClient;

    private static List<Integer> stepsDay;
    private static List<Integer> stepsWeek;
    private static List<Integer> stepsMonth;
    private static List<Integer> stepsYear;

    private static List<Integer> caloriesDay;
    private static List<Integer> caloriesWeek;
    private static List<Integer> caloriesMonth;
    private static List<Integer> caloriesYear;

    private static List<Integer> heartDay;
    private static List<Integer> heartWeek;
    private static List<Integer> heartMonth;
    private static List<Integer> heartYear;

    private static List<Integer> weightDay;
    private static List<Integer> weightWeek;
    private static List<Integer> weightMonth;
    private static List<Integer> weightYear;

    private static List<Integer> painDay;
    private static List<Integer> painWeek;
    private static List<Integer> painMonth;
    private static List<Integer> painYear;

    private static boolean isDataAvailable;
    private static Map<List<Integer>, String> jsonCollections = new HashMap<>();

    private static final int DAY_BOUND = 23;
    private static final int WEEK_BOUND = 7;
    private static final int MONTH_BOUND = 5;
    private static final int YEAR_BOUND = 12;

    private ProgressDialog mDialog;

    private enum TimeFilter {
        DAY, WEEK, MONTH, YEAR
    }

    public ProgressFragment() {
        launchUrl = "index.html#/WebView/metrics"; // default launch URL
        route = "metrics"; // default route
    }

    public void setMetricViewType(HealthDataRetriever.DataType type) {
        switch (type) {
            case HEART_RATE:
                launchUrl = "index.html#/WebView/metrics_hr_day";
                route = "metrics_hr_day";
                break;
            case STEPS:
                launchUrl = "index.html#/WebView/metrics_steps_day";
                route = "metrics_steps_day";
                break;
            case WEIGHT:
                launchUrl = "index.html#/WebView/metrics_weight_day";
                route = "metrics_weight_day";
                break;
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View layout = inflater.inflate(R.layout.fragment_progress, container, false);
        setupView(layout);
        return layout;
    }

    private void setupView(View view) {
        mClient = HealthDataRetriever.getClient(getActivity());
        if (!mClient.isConnected()) {
            mClient.connect();
        }

        mWebView = (MILWebView) view.findViewById(R.id.webview);
        mWebView.setOnPageChangeListener(this);
        mWebView.launchUrl(launchUrl);
    }

    @Override
    public void onDetach() {
        super.onDetach();

        // effectively unregister this fragment from the WebView if it gets detached from Activity
        if (mWebView != null) {
            mWebView.setOnPageChangeListener(null);
        }
    }

    @Override
    public void onPageChange(List<String> urlChunks) {
        // listen for page changes
        if (!mClient.isConnected()) {
            mClient.connect();
            return;
        }

        if (!isDataAvailable) {
            // Health data not previously cached, collect it
            String loadingMessage = getString(R.string.loading_fit_data);
            mDialog = ProgressDialog.show(getActivity(), null, loadingMessage, true);

            fetchData(TimeFilter.DAY);
            fetchData(TimeFilter.WEEK);
            fetchData(TimeFilter.MONTH);
            fetchData(TimeFilter.YEAR);
        } else {
            route = urlChunks.get(urlChunks.size() - 1);
            injectData();
        }
    }

    private void injectData() {
        List<List<Integer>> collections = new ArrayList<>();
        switch (route) {
            case "metrics":
            case "metrics_day":
                collections.add(heartDay);
                collections.add(weightDay);
                collections.add(stepsDay);
                collections.add(caloriesDay);
                collections.add(painDay);
                break;
            case "metrics_week":
                collections.add(heartWeek);
                collections.add(weightWeek);
                collections.add(stepsWeek);
                collections.add(caloriesWeek);
                collections.add(painWeek);
                break;
            case "metrics_month":
                collections.add(heartMonth);
                collections.add(weightMonth);
                collections.add(stepsMonth);
                collections.add(caloriesMonth);
                collections.add(painMonth);
                break;
            case "metrics_year":
                collections.add(heartYear);
                collections.add(weightYear);
                collections.add(stepsYear);
                collections.add(caloriesYear);
                collections.add(painYear);
                break;
            case "metrics_hr_day":
                collections.add(heartDay);
                break;
            case "metrics_hr_week":
                collections.add(heartWeek);
                break;
            case "metrics_hr_month":
                collections.add(heartMonth);
                break;
            case "metrics_hr_year":
                collections.add(heartYear);
                break;
            case "metrics_weight_day":
                collections.add(weightDay);
                break;
            case "metrics_weight_week":
                collections.add(weightWeek);
                break;
            case "metrics_weight_month":
                collections.add(weightMonth);
                break;
            case "metrics_weight_year":
                collections.add(weightYear);
                break;
            case "metrics_steps_day":
                collections.add(stepsDay);
                break;
            case "metrics_steps_week":
                collections.add(stepsWeek);
                break;
            case "metrics_steps_month":
                collections.add(stepsMonth);
                break;
            case "metrics_steps_year":
                collections.add(stepsYear);
                break;
            case "metrics_calories_day":
                collections.add(caloriesDay);
                break;
            case "metrics_calories_week":
                collections.add(caloriesWeek);
                break;
            case "metrics_calories_month":
                collections.add(caloriesMonth);
                break;
            case "metrics_calories_year":
                collections.add(caloriesYear);
                break;
            case "metrics_pain_day":
                collections.add(painDay);
                break;
            case "metrics_pain_week":
                collections.add(painWeek);
                break;
            case "metrics_pain_month":
                collections.add(painMonth);
                break;
            case "metrics_pain_year":
                collections.add(painYear);
                break;
        }

        mWebView.setLanguage(getResources().getConfiguration().locale);

        final StringBuilder builder = new StringBuilder();
        builder.append(MILWebView.getScopeObject());
        builder.append("scope.surrenderRouteControl();");

        if (!route.equals("metrics") && !route.equals("metrics_day")
                && !route.equals("metrics_week") && !route.equals("metrics_month")
                && !route.equals("metrics_year")) {
            gatherDetailedData(collections.get(0), route, builder);
        }

        builder.append("scope.applyData([");
        builder.append(JSONBuilderHelper(collections));
        builder.append("]);");
        builder.append("scope.resumeRouteControl();");

        Log.i(TAG, "JavaScript Injection Code: " + builder.toString());

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                mWebView.injectJavaScript(builder.toString());
            }
        }, 250);
    }

    private void gatherDetailedData(List<Integer> data, String route, StringBuilder builder) {
        Locale locale = getResources().getConfiguration().locale;
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);

        // set performance
        String performance = numberFormat.format(data.get(data.size() - 1));
        builder.append("scope.setPerformance('");
        builder.append(performance);
        builder.append("');");

        // set time frame
        String format;
        String unit;
        String timeSpan = route.split("_")[2];
        switch (timeSpan) {
            case "day":
                format = "MMMM d - ha";
                unit = "Today";
                break;
            case "week":
                format = "MMMM d";
                unit = "Today";
                break;
            case "month":
                format = "MMM d";
                unit = "This Week";
                break;
            default:
                format = "MMMM yyyy";
                unit = "This Month";
                break;
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat(format, locale);
        String timeFrame = dateFormat.format(new Date());

        // add additional time frame text for month
        if (timeSpan.equals("month")) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.WEEK_OF_YEAR, -1);
            dateFormat.applyLocalizedPattern("MMMM d");
            timeFrame = dateFormat.format(calendar.getTime()) + " - " + timeFrame;
        }

        builder.append("scope.setTimeFrame('");
        builder.append(timeFrame);
        builder.append("');");

        builder.append("scope.setUnit('");
        builder.append(unit);
        builder.append("');");

        // set optional goal
        if (route.contains("steps") || route.contains("calories")) {
            String goal;
            if (route.contains("steps")) {
                goal = numberFormat.format(DataManager.getCurrentPatient().getStepGoal());
            } else {
                goal = numberFormat.format(DataManager.getCurrentPatient().getCalorieGoal());
            }

            builder.append("scope.setGoal('");
            builder.append(goal);
            builder.append("');");
        }
    }

    private void verifyDataIntegrity() {
        boolean isAvailable = stepsDay != null;
        isAvailable = isAvailable && stepsWeek != null;
        isAvailable = isAvailable && stepsMonth != null;
        isAvailable = isAvailable && stepsYear != null;
        isAvailable = isAvailable && heartDay != null;
        isAvailable = isAvailable && heartWeek != null;
        isAvailable = isAvailable && heartMonth != null;
        isAvailable = isAvailable && heartYear != null;
        isAvailable = isAvailable && weightDay != null;
        isAvailable = isAvailable && weightWeek != null;
        isAvailable = isAvailable && weightMonth != null;
        isAvailable = isAvailable && weightYear != null;
        isAvailable = isAvailable && caloriesDay != null && caloriesDay.size() == DAY_BOUND;
        isAvailable = isAvailable && caloriesWeek != null && caloriesWeek.size() == WEEK_BOUND;
        isAvailable = isAvailable && caloriesMonth != null && caloriesMonth.size() == MONTH_BOUND;
        isAvailable = isAvailable && caloriesYear != null && caloriesYear.size() == YEAR_BOUND;
        isAvailable = isAvailable && painDay != null;
        isAvailable = isAvailable && painWeek != null;
        isAvailable = isAvailable && painMonth != null;
        isAvailable = isAvailable && painYear != null;

        if (isAvailable) {
            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    isDataAvailable = true;
                    injectData();
                    mDialog.dismiss();
                }
            });
        }
    }

    private void fetchData(final TimeFilter filter) {
        fetchPainData(filter);

        Calendar calendar = Calendar.getInstance();
        Date endDate = new Date();
        calendar.setTime(endDate);

        TimeUnit unit;
        int interval;
        int bound;
        switch (filter) {
            case DAY:
                calendar.add(Calendar.DAY_OF_YEAR, -1);
                calendar.add(Calendar.HOUR, 1);
                unit = TimeUnit.HOURS;
                interval = 1;
                bound = DAY_BOUND;
                break;
            case WEEK:
                calendar.add(Calendar.WEEK_OF_YEAR, -1);
                unit = TimeUnit.DAYS;
                interval = 1;
                bound = WEEK_BOUND;
                break;
            case MONTH:
                calendar.add(Calendar.MONTH, -1);
                unit = TimeUnit.DAYS;
                interval = 7;
                bound = MONTH_BOUND;
                break;
            case YEAR:
            default:
                calendar.add(Calendar.YEAR, -1);
                calendar.add(Calendar.MONTH, 1);
                unit = TimeUnit.DAYS;
                interval = 30;
                bound = YEAR_BOUND;
                break;
        }

        Date startDate = calendar.getTime();

        HealthDataRetriever.Builder builder = new HealthDataRetriever.Builder()
                .startDate(startDate)
                .endDate(endDate)
                .timeUnit(unit)
                .timeInterval(interval);

        HealthDataRetriever stepsRetriever = builder
                .dataType(HealthDataRetriever.DataType.STEPS)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(List<Integer> data) {
                        switch (filter) {
                            case DAY:
                                stepsDay = data;
                                break;
                            case WEEK:
                                stepsWeek = data;
                                break;
                            case MONTH:
                                stepsMonth = data;
                                break;
                            case YEAR:
                                stepsYear = data;
                                break;
                        }

                        verifyDataIntegrity();
                    }
                }).build();
        stepsRetriever.retrieve(mClient);

        HealthDataRetriever heartRetriever = builder
                .dataType(HealthDataRetriever.DataType.HEART_RATE)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(List<Integer> data) {
                        switch (filter) {
                            case DAY:
                                heartDay = data;
                                break;
                            case WEEK:
                                heartWeek = data;
                                break;
                            case MONTH:
                                heartMonth = data;
                                break;
                            case YEAR:
                                heartYear = data;
                                break;
                        }

                        verifyDataIntegrity();
                    }
                }).build();
        heartRetriever.retrieve(mClient);

        HealthDataRetriever weightRetriever = builder
                .dataType(HealthDataRetriever.DataType.WEIGHT)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(List<Integer> data) {
                        switch (filter) {
                            case DAY:
                                weightDay = data;
                                break;
                            case WEEK:
                                weightWeek = data;
                                break;
                            case MONTH:
                                weightMonth = data;
                                break;
                            case YEAR:
                                weightYear = data;
                                break;
                        }

                        verifyDataIntegrity();
                    }
                }).build();
        weightRetriever.retrieve(mClient);

        calendar.setTime(endDate);
        int caloriesInterval = bound == DAY_BOUND ? Calendar.HOUR : Calendar.DAY_OF_YEAR;

        for (int i = 0; i < bound; i++) {
            endDate = calendar.getTime();
            calendar.add(caloriesInterval, -interval);
            startDate = calendar.getTime();

            HealthDataRetriever caloriesRetriever = builder
                    .startDate(startDate)
                    .endDate(endDate)
                    .dataType(HealthDataRetriever.DataType.CALORIES)
                    .handler(new HealthDataRetriever.Handler() {
                        @Override
                        public void handle(List<Integer> data) {
                            int sum = 0;
                            for (Integer datum : data) {
                                sum += datum;
                            }

                            switch (filter) {
                                case DAY:
                                    if (caloriesDay == null) {
                                        caloriesDay = new ArrayList<>();
                                    }
                                    caloriesDay.add(0, sum);
                                    break;
                                case WEEK:
                                    if (caloriesWeek == null) {
                                        caloriesWeek = new ArrayList<>();
                                    }
                                    caloriesWeek.add(0, sum);
                                    break;
                                case MONTH:
                                    if (caloriesMonth == null) {
                                        caloriesMonth = new ArrayList<>();
                                    }
                                    caloriesMonth.add(0, sum);
                                    break;
                                case YEAR:
                                    if (caloriesYear == null) {
                                        caloriesYear = new ArrayList<>();
                                    }
                                    caloriesYear.add(0, sum);
                                    break;
                            }

                            verifyDataIntegrity();
                        }
                    }).build();
            caloriesRetriever.retrieve(mClient);
        }
    }

    private void fetchPainData(TimeFilter filter) {
        List<Integer> painData = new ArrayList<>();

        int interval = 0;
        int addInterval = Calendar.DAY_OF_YEAR;
        int bound = 0;
        switch (filter) {
            case DAY:
                interval = 1;
                addInterval = Calendar.HOUR;
                bound = DAY_BOUND;
                painDay = painData;
                break;
            case WEEK:
                interval = 1;
                bound = WEEK_BOUND;
                painWeek = painData;
                break;
            case MONTH:
                interval = 7;
                bound = MONTH_BOUND;
                painMonth = painData;
                break;
            case YEAR:
                interval = 30;
                bound = YEAR_BOUND;
                painYear = painData;
                break;
        }

        Realm realm = Realm.getInstance(getActivity());
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        for (int i = 0; i < bound; i++) {
            Date end = calendar.getTime();
            calendar.add(addInterval, -interval);
            Date start = calendar.getTime();

            RealmResults<PainReport> results = realm.where(PainReport.class)
                    .between("date", start, end).findAll();

            int sum = 0;
            for (PainReport report : results) {
                sum += report.getPainAmount();
            }

            if (results.isEmpty()) {
                painData.add(0, sum);
            } else {
                painData.add(0, sum / results.size());
            }
        }

        verifyDataIntegrity();
    }

    private String JSONBuilderHelper(List<List<Integer>> collections) {
        StringBuilder builder = new StringBuilder();

        int buffer = 5 - collections.size();
        for (int i = 0; i < buffer; i++) {
            collections.add(collections.get(0));
        }

        for (int i = 0; i < collections.size(); i++) {
            builder.append(getJSONData(collections.get(i)));
            if (i < collections.size() - 1) {
                builder.append(",");
            }
        }

        return builder.toString();
    }

    private String getJSONData(List<Integer> dataPoints) {
        if (!jsonCollections.containsKey(dataPoints)) {
            StringBuilder builder = new StringBuilder("'[");

            for (int i = 0; i < dataPoints.size(); i++) {
                if (i > 0) {
                    builder.append(",");
                }

                builder.append("{\"x\":\"");
                builder.append(i + 1);
                builder.append("\",\"y\":");
                builder.append(dataPoints.get(i));
                builder.append("}");
            }

            builder.append("]'");
            jsonCollections.put(dataPoints, builder.toString());
        }

        return jsonCollections.get(dataPoints);
    }

    /**
     * Utility method that will clear the data that was previously cached in ProgressFragment.
     * This is useful for when you want to see updates to the data being displayed by the
     * fragment. Note that data is only cached for the life cycle of the app and to clear the cache
     * sooner, this method needs to be called.
     */
    public static void clearData() {
        isDataAvailable = false;

        heartDay = null;
        heartWeek = null;
        heartMonth = null;
        heartYear = null;

        weightDay = null;
        weightWeek = null;
        weightMonth = null;
        weightYear = null;

        stepsDay = null;
        stepsWeek = null;
        stepsMonth = null;
        stepsYear = null;

        caloriesDay = null;
        caloriesWeek = null;
        caloriesMonth = null;
        caloriesYear = null;

        painDay = null;
        painWeek = null;
        painMonth = null;
        painYear = null;
    }

}
