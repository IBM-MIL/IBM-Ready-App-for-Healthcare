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

import java.text.NumberFormat;
import java.util.Locale;

/**
 * StepsMetricsTab provides additional UI styling and methods for settings data specific to steps
 * metrics. It is meant to be directly instantiable, unlike MetricsTab.
 *
 * @author John Petitto
 * @see MetricsTab
 */
public class StepsMetricsTab extends MetricsTab {
    private static final int MAX_STEPS = 9999;

    public StepsMetricsTab(Context context, AttributeSet attrs) {
        super(context, attrs);

        setMetricsBackgroundColor(BackgroundColors.BLUE);
        setMetricsForegroundColor(ForegroundColors.WHITE);
        setMetricsTitle(getResources().getString(R.string.steps));
        setMetricsIcon(getResources().getDrawable(R.drawable.steps_icon_tab));

        // default values to populate view
        setSteps(0);
        setStepsGoal(0);
    }

    /**
     * @param steps The number of steps the user has taken towards their goal.
     * @see #setStepsGoal(int)
     */
    public void setSteps(int steps) {
        if (steps > MAX_STEPS) {
            steps = MAX_STEPS;
        }
        setMetricsNumber(Integer.toString(steps));
    }

    /**
     * @param stepsGoal The user's goal for number of steps.
     */
    public void setStepsGoal(int stepsGoal) {
        String steps = NumberFormat.getNumberInstance(Locale.US).format(stepsGoal);
        String startMessage = getResources().getString(R.string.out_of) + " ";
        String trailMessage = " " + getResources().getString(R.string.goal) + ".";

        SpannableString details = new SpannableString(startMessage + steps + trailMessage);
        details.setSpan(new StyleSpan(Typeface.BOLD),
                startMessage.length(), startMessage.length() + steps.length(), 0);

        setMetricsDetail(details);
    }

}
