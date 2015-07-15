/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.datamanager.worklight;

import android.util.Log;

import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.models.Patient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import org.json.JSONObject;

public class UserDataInvokeListener implements WLResponseListener {
    private static final String TAG = UserDataInvokeListener.class.getSimpleName();

    public LoginListenerInterface loginCallback;

    public void onSuccess(WLResponse response) {
        JSONObject jsonResp = response.getResponseJSON();
        Log.i(TAG, "User data succeeded, received: " + jsonResp);

        Patient currentPatient = new Patient(jsonResp);
        DataManager dataManager = DataManager.getInstance();
        dataManager.setCurrentPatient(currentPatient);

        loginCallback.handleLogin(LoginListenerInterface.ResultType.SUCCESS);
    }

    public void onFailure(WLFailResponse response) {
        Log.i(TAG, "User data failed, error: " + response.getErrorMsg());
        loginCallback.handleLogin(LoginListenerInterface.ResultType.FAILURE);
    }

}
