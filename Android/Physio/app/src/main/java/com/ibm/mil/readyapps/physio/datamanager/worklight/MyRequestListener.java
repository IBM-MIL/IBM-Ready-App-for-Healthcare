/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.datamanager.worklight;

import android.util.Log;

import com.worklight.wlclient.WLRequestListener;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;

public class MyRequestListener implements WLRequestListener {
    private static final String TAG = MyRequestListener.class.getSimpleName();

    @Override
    public void onSuccess(WLResponse response) {
        Log.i(TAG, "Logout Success\n" + response.getResponseText());
    }

    @Override
    public void onFailure(WLFailResponse response) {
        Log.i(TAG, "Logout Failure\n" + response.getErrorMsg());
    }

}
