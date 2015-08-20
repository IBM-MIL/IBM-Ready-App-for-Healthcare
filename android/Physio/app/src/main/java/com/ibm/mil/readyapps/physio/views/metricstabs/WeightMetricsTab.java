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
 * WeightMetricsTab provides additional UI styling and methods for setting data specific to weight
 * metrics. It is meant to be directly instantiable, unlike MetricsTab.
 *
 * @author John Petitto
 * @see MetricsTab
 */
public class WeightMetricsTab extends MetricsTab {

    public WeightMetricsTab(Context context, AttributeSet attrs) {
        super(context, attrs);

        setMetricsBackgroundColor(BackgroundColors.GRAY);
        setMetricsForegroundColor(ForegroundColors.DARK_GRAY);
        setMetricsTitle(getResources().getString(R.string.weight));
        setMetricsIcon(getResources().getDrawable(R.drawable.weight_icon_tab));

        // default values to populate view
        setWeight(0);
        setNetWeight(0);
    }

    /**
     * @param weight The users current weight.
     */
    public void setWeight(int weight) {
        setMetricsNumber(Integer.toString(weight));
        setMetricsNumberUnit(getResources().getString(R.string.lbs));
    }

    /**
     * @param netWeight The users net weight gained or lost for the week.
     */
    public void setNetWeight(int netWeight) {
        String pounds = Integer.toString(Math.abs(netWeight));
        String message;

        if (netWeight < 0) {
            message = getResources().getString(R.string.lbs_lost);
        } else {
            message = getResources().getString(R.string.lbs_gained);
        }

        SpannableString details = new SpannableString(pounds + " " + message + ".");
        details.setSpan(new StyleSpan(Typeface.BOLD), 0, pounds.length(), 0);
        setMetricsDetail(details);
    }

}
