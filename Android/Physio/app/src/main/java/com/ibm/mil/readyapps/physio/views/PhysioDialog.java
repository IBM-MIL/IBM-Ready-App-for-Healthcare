/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.views;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Typeface;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;

/**
 * A custom dialog that matches the UI for showing a single button.
 */
public class PhysioDialog extends Dialog {

    public PhysioDialog(Context context) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE); // hide dialog title
        setContentView(R.layout.dialog_physio);

        // make dialog fill width of screen
        WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
        layoutParams.copyFrom(getWindow().getAttributes());
        layoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(layoutParams);

        // set custom typefaces
        Typeface robotoRegular = AndroidUtils.robotoRegular(context);
        getPrimaryMessage().setTypeface(robotoRegular);
        getButton().setTypeface(robotoRegular);
    }

    /**
     *
     * @return The icon of of the dialog
     */
    public ImageView getIcon() {
        return (ImageView) findViewById(R.id.icon);
    }

    /**
     *
     * @return The primary message of the dialog
     */
    public TextView getPrimaryMessage() {
        return (TextView) findViewById(R.id.primary_message);
    }

    /**
     *
     * @return The secondary message of the dialog
     */
    public TextView getSecondaryMessage() {
        return (TextView) findViewById(R.id.secondary_message);
    }

    /**
     *
     * @return The button of the dialog
     */
    public Button getButton() {
        return (Button) findViewById(R.id.button);
    }

    public void setOnClickListener(View.OnClickListener listener) {
        findViewById(R.id.dialog_window).setOnClickListener(listener);
    }

}
