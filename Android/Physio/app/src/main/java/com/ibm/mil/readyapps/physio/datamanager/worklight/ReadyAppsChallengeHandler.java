/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.datamanager.worklight;

import android.app.Activity;
import android.content.Intent;

import com.ibm.mil.readyapps.physio.activities.LoginActivity;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLProcedureInvocationData;
import com.worklight.wlclient.api.WLRequestOptions;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.challengehandler.ChallengeHandler;

import org.json.JSONException;

public class ReadyAppsChallengeHandler extends ChallengeHandler {
    public static final String CLIENT_REALM = "SingleStepAuthRealm";

    private Activity parentActivity;
    public LoginListenerInterface loginCallback;

    public ReadyAppsChallengeHandler(Activity activity, String realm) {
        super(realm);
        parentActivity = activity;
    }

    @Override
    public void onSuccess(WLResponse response) {
        submitSuccess(response);
    }

    @Override
    public void onFailure(WLFailResponse response) {
        submitFailure(response);
    }

    @Override
    public boolean isCustomResponse(WLResponse response) {
        try {
            if (response.getResponseJSON().isNull("authRequired") != true
                    && response.getResponseJSON().getBoolean("authRequired") == true) {
                return true;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void handleChallenge(WLResponse response) {
        Intent login = new Intent(parentActivity, LoginActivity.class);
        parentActivity.startActivityForResult(login, 1);
    }

    public void submitLogin(String userName, String password, String locale) {
        Object[] parameters = new Object[]{userName, password, locale};
        WLProcedureInvocationData invocationData =
                new WLProcedureInvocationData("ReadyAppsAdapter", "submitAuthentication");
        invocationData.setParameters(parameters);
        WLRequestOptions options = new WLRequestOptions();
        options.setTimeout(30000);

        WLClient client = WLClient.getInstance();
        LoginInvokeListener loginInvokeListener = new LoginInvokeListener();
        loginInvokeListener.loginCallback = loginCallback;
        client.invokeProcedure(invocationData, loginInvokeListener, options);
    }

}
