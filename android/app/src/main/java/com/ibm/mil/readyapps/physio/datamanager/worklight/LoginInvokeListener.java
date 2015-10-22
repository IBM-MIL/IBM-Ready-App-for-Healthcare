/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.datamanager.worklight;

import android.util.Log;

import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLProcedureInvocationData;
import com.worklight.wlclient.api.WLRequestOptions;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import org.json.JSONException;
import org.json.JSONObject;

public class LoginInvokeListener implements WLResponseListener {
    private static final String TAG = LoginInvokeListener.class.getSimpleName();

    public LoginListenerInterface loginCallback;

    public void onSuccess(WLResponse response) {
        JSONObject jsonResp = response.getResponseJSON();

        String userID = "";
        try {
            JSONObject auth = jsonResp.getJSONObject("WL-Authentication-Success");
            JSONObject realm = auth.getJSONObject(ReadyAppsChallengeHandler.CLIENT_REALM);
            userID = realm.getString("userId");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        WLProcedureInvocationData invocationData =
                new WLProcedureInvocationData("HealthcareAdapter", "getUserObject");
        Object[] parameters = new Object[]{userID};
        invocationData.setParameters(parameters);
        WLRequestOptions options = new WLRequestOptions();
        options.setTimeout(30000);

        WLClient client = WLClient.getInstance();
        UserDataInvokeListener userDataInvokeListener = new UserDataInvokeListener();
        userDataInvokeListener.loginCallback = loginCallback;
        client.invokeProcedure(invocationData, userDataInvokeListener, options);

        Log.i(TAG, "Login succeeded, received: " + jsonResp.toString());
    }

    public void onFailure(WLFailResponse response) {
        Log.e(TAG, "Login failed, error: " + response.getErrorMsg());
        loginCallback.handleLogin(LoginListenerInterface.ResultType.FAILURE);
    }

}
