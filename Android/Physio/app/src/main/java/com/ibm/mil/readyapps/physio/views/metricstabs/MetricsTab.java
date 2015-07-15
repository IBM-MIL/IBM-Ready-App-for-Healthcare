/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.views.metricstabs;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;

/**
 * MetricsTab is responsible for the general look-and-feel of a metrics tab in the LandingActivity.
 * It is not meant to be directly instantiated (hence the package-private access control). Instead,
 * you should instantiate one of a number of classes that extend MetricsTab, such as
 * HeartRateMetricsTab.
 *
 * @author John Petitto
 * @see com.ibm.mil.readyapps.physio.views.metricstabs.HeartRateMetricsTab
 * @see com.ibm.mil.readyapps.physio.views.metricstabs.WeightMetricsTab
 * @see com.ibm.mil.readyapps.physio.views.metricstabs.StepsMetricsTab
 */
class MetricsTab extends LinearLayout {

    /**
     * A set of predefined background colors.
     */
    protected enum BackgroundColors {
        RED, GRAY, BLUE
    }

    /**
     * A set of predefined background colors.
     */
    protected enum ForegroundColors {
        DARK_GRAY, WHITE
    }

    /**
     * Do not directly instantiate the MetricsTab class unless you are sub-classing. Instead, use
     * one of the existing classes that extend MetricsTab, such as HeartRateMetricsTab.
     *
     * @param context
     * @param attrs
     * @see com.ibm.mil.readyapps.physio.views.metricstabs.HeartRateMetricsTab
     * @see com.ibm.mil.readyapps.physio.views.metricstabs.WeightMetricsTab
     * @see com.ibm.mil.readyapps.physio.views.metricstabs.StepsMetricsTab
     */
    protected MetricsTab(Context context, AttributeSet attrs) {
        super(context, attrs);

        setOrientation(LinearLayout.VERTICAL);
        setGravity(Gravity.CENTER_VERTICAL);

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.metrics_tab, this, true);

        int padding = AndroidUtils.pixelsToDip(getContext(), 8);
        setPadding(padding, padding, padding, padding);

        LayoutParams params = new LayoutParams
                (ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        params.setMargins(0, 0, 0, AndroidUtils.pixelsToDip(getContext(), 15));
        setLayoutParams(params);
    }

    /**
     * @param color A predefined color that will be the background color for the metrics tab.
     * @see com.ibm.mil.readyapps.physio.views.metricstabs.MetricsTab.BackgroundColors
     */
    protected void setMetricsBackgroundColor(BackgroundColors color) {
        switch (color) {
            case RED:
                setBackgroundResource(R.drawable.metrics_red);
                break;
            case GRAY:
                setBackgroundResource(R.drawable.metrics_gray);
                break;
            case BLUE:
                setBackgroundResource(R.drawable.metrics_blue);
                break;
        }
    }

    /**
     * @param color A predefined color that will be the foreground color for the metrics tab.
     * @see com.ibm.mil.readyapps.physio.views.metricstabs.MetricsTab.ForegroundColors
     */
    protected void setMetricsForegroundColor(ForegroundColors color) {
        int foregroundColor = 0;

        switch (color) {
            case DARK_GRAY:
                foregroundColor = getResources().getColor(R.color.ready_dark_gray);
                break;
            case WHITE:
                foregroundColor = getResources().getColor(android.R.color.white);
                break;
        }

        setTextColor(foregroundColor);
        View divider = findViewById(R.id.divider);
        divider.setBackgroundColor(foregroundColor);
    }

    // helper method used by setForegroundColor()
    private void setTextColor(int color) {
        TextView metricsTitle = (TextView) findViewById(R.id.metrics_title);
        metricsTitle.setTextColor(color);
        TextView metricsNumber = (TextView) findViewById(R.id.metrics_number);
        metricsNumber.setTextColor(color);
        TextView metricsNumberUnit = (TextView) findViewById(R.id.metrics_number_unit);
        metricsNumberUnit.setTextColor(color);
        TextView metricsDetail = (TextView) findViewById(R.id.metrics_detail);
        metricsDetail.setTextColor(color);
    }

    /**
     * @param title The title for the metrics tab. You can pass a SpannableString to provide
     *              additional formatting for the text.
     */
    protected void setMetricsTitle(CharSequence title) {
        TextView metricsTitle = (TextView) findViewById(R.id.metrics_title);
        metricsTitle.setText(title);
    }

    /**
     * @param number The number value for the metrics tab. You can pass a SpannableString to
     *               provide additional formatting for the text.
     */
    protected void setMetricsNumber(CharSequence number) {
        TextView metricsNumber = (TextView) findViewById(R.id.metrics_number);
        metricsNumber.setText(number);
        metricsNumber.setTypeface(AndroidUtils.robotoBold(getContext()));
    }

    /**
     * @param unit The unit of measurement for the number value of the metrics tab. Simply do not
     *             invoke this method if no unit is required. You can pass a SpannableString to
     *             provide additional formatting for the text.
     * @see #setMetricsNumber(CharSequence)
     */
    protected void setMetricsNumberUnit(CharSequence unit) {
        TextView metricsUnit = (TextView) findViewById(R.id.metrics_number_unit);
        metricsUnit.setText(unit);
    }

    /**
     * @param detail The detail text is for providing any additional information at the bottom of a
     *               metrics tab. You can pass a SpannableString to provide additional formatting
     *               for the text.
     */
    protected void setMetricsDetail(CharSequence detail) {
        TextView metricsDetail = (TextView) findViewById(R.id.metrics_detail);
        metricsDetail.setText(detail);
    }

    /**
     * @param icon The icon for the metrics tab.
     */
    protected void setMetricsIcon(Drawable icon) {
        ImageView metricsIcon = (ImageView) findViewById(R.id.metrics_icon);
        metricsIcon.setImageDrawable(icon);
    }

}
