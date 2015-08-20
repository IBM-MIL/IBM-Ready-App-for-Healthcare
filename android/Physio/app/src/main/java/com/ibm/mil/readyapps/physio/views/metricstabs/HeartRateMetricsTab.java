/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.views.metricstabs;

import android.content.Context;
import android.graphics.Typeface;
import android.text.SpannableString;
import android.text.style.StyleSpan;
import android.util.AttributeSet;

import com.ibm.mil.readyapps.physio.R;

/**
 * HeartRateMetricsTab provides additional UI styling and methods for setting data specific to
 * heart rate metrics. It is meant to be directly instantiable, unlike MetricsTab.
 *
 * @author John Petitto
 * @see MetricsTab
 */
public class HeartRateMetricsTab extends MetricsTab {

    public HeartRateMetricsTab(Context context, AttributeSet attrs) {
        super(context, attrs);

        setMetricsBackgroundColor(BackgroundColors.RED);
        setMetricsForegroundColor(ForegroundColors.WHITE);
        setMetricsTitle(getResources().getString(R.string.heart_rate));
        setMetricsIcon(getResources().getDrawable(R.drawable.heart_icon_tab));

        // default values to populate view
        setBeatsPerMin(0);
        setMinMaxBpm(0, 0);
    }

    /**
     * @param bpm The average beats per minute value. This is the main value shown on the
     *            HeartRateMetricsTab.
     */
    public void setBeatsPerMin(int bpm) {
        setMetricsNumber(Integer.toString(bpm));
        setMetricsNumberUnit(getResources().getString(R.string.bpm));
    }

    /**
     * @param minBpm The minimum beats per minute value.
     * @param maxBpm The maximum beats per minute value.
     */
    public void setMinMaxBpm(int minBpm, int maxBpm) {
        String minVal = Integer.toString(minBpm);
        String maxVal = Integer.toString(maxBpm);
        String min = " " + getResources().getString(R.string.min) + "  ";
        String max = " " + getResources().getString(R.string.max);

        SpannableString details =
                new SpannableString(minVal + min.toUpperCase() + maxVal + max.toUpperCase());
        details.setSpan(new StyleSpan(Typeface.BOLD), 0, minVal.length(), 0);
        int maxValIndex = minVal.length() + min.length();
        details.setSpan(new StyleSpan(Typeface.BOLD),
                maxValIndex, maxValIndex + maxVal.length(), 0);

        setMetricsDetail(details);
    }

}
