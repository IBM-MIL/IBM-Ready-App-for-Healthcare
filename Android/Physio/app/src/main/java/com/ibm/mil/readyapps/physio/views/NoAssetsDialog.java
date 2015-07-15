/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.views;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.ibm.mil.readyapps.physio.R;

/**
 * A custom dialog that matches the UI for alerting the user when no assets are available.
 */
public class NoAssetsDialog extends PhysioDialog {

    public NoAssetsDialog(final Context context) {
        super(context);

        getIcon().setImageDrawable(context.getResources().getDrawable(R.drawable.x_blue));
        getPrimaryMessage().setText(context.getString(R.string.no_assets));
        getSecondaryMessage().setVisibility(View.GONE);
        getButton().setVisibility(View.GONE);
        setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cancel();
            }
        });
        setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                ((Activity) context).onBackPressed();
            }
        });
    }

}
