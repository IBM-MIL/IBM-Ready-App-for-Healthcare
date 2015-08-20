/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.datamanager.worklight;

import android.util.Log;

import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

public class ReadyAppsConnectionListener implements WLResponseListener {
    private static final String TAG = ReadyAppsConnectionListener.class.getSimpleName();

    @Override
    public void onSuccess(WLResponse response) {
        Log.i(TAG, "Connection Successful\n" + response.getResponseText());
    }

    @Override
    public void onFailure(WLFailResponse response) {
        Log.i(TAG, "Connection Failure\n" + response.getErrorMsg());
    }

}
