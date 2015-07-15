/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.views;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;

/**
 * A custom dialog that matches the UI for alerting the user to make a choice.
 */
public class PhysioAlertDialog extends Dialog {

    public PhysioAlertDialog(Context context) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_alert_physio);

        // make dialog fill width of screen
        WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
        layoutParams.copyFrom(getWindow().getAttributes());
        layoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(layoutParams);

        // set custom typefaces
        Typeface robotoRegular = AndroidUtils.robotoRegular(context);
        TextView primaryMessage = (TextView) findViewById(R.id.primary_message);
        primaryMessage.setTypeface(robotoRegular);
        TextView positiveMessage = (TextView) findViewById(R.id.positive_message);
        positiveMessage.setTypeface(robotoRegular);
        TextView negativeMessage = (TextView) findViewById(R.id.negative_message);
        negativeMessage.setTypeface(robotoRegular);
    }

    /**
     *
     * @param text The main message of the alert dialog
     */
    public void setPrimaryText(CharSequence text) {
        ((TextView) findViewById(R.id.primary_message)).setText(text);
    }

    /**
     *
     * @param text The secondary message of the alert dialog
     */
    public void setSecondaryText(CharSequence text) {
        ((TextView) findViewById(R.id.secondary_message)).setText(text);
    }

    /**
     *
     * @param hide Hide the secondary message
     */
    public void hideSecondaryText(boolean hide) {
        TextView textView = (TextView) findViewById(R.id.secondary_message);
        if (hide) {
            textView.setVisibility(View.GONE);
        } else {
            textView.setVisibility(View.VISIBLE);
        }
    }

    /**
     *
     * @param drawable The background drawable for the Positive and Negative buttons
     */
    public void setButtonDrawable(Drawable drawable) {
        findViewById(R.id.button_bar).setBackground(drawable);
    }

    /**
     *
     * @param text The positive button text
     */
    public void setPositiveText(CharSequence text) {
        ((TextView) findViewById(R.id.positive_message)).setText(text);
    }

    /**
     *
     * @param listener The positive button click listener
     */
    public void setPositiveClickListener(View.OnClickListener listener) {
        (findViewById(R.id.positive_message)).setOnClickListener(listener);
    }

    /**
     *
     * @param text The negative button text
     */
    public void setNegativeText(CharSequence text) {
        ((TextView) findViewById(R.id.negative_message)).setText(text);
    }

    /**
     *
     * @param listener The negative button click listener
     */
    public void setNegativeClickListener(View.OnClickListener listener) {
        (findViewById(R.id.negative_message)).setOnClickListener(listener);
    }

}
