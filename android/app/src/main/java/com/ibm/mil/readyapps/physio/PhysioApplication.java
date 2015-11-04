package com.ibm.mil.readyapps.physio;

import android.app.Application;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.Tracker;

public class PhysioApplication extends Application {
    public static GoogleAnalytics analytics;
    public static Tracker tracker;

    @Override
    public void onCreate() {
        super.onCreate();

        analytics = GoogleAnalytics.getInstance(this);
        String analyticsKey = getString(R.string.analyticsKey);
        tracker = analytics.newTracker(analyticsKey);
        tracker.enableAutoActivityTracking(true);
    }
}