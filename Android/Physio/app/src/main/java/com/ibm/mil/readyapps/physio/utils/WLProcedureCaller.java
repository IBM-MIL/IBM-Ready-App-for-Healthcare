/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 * This sample program is provided AS IS and may be used, executed, copied and modified without
 * royalty payment by customer (a) for its own instruction and study, (b) in order to develop
 * applications designed to run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own products.
 */

package com.ibm.mil.readyapps.physio.utils;

import android.net.Uri;
import android.util.Log;

import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLProcedureInvocationData;
import com.worklight.wlclient.api.WLRequestOptions;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import org.json.JSONObject;

/**
 * Service class for invoking a WL procedure. Provides mechanisms for specifying parameters and
 * showing a progress dialog while the call is being performed.
 *
 * @author Ricardo Olivieri
 * @author John Petitto
 */
public class WLProcedureCaller {
    private static final String TAG = WLProcedureCaller.class.getName();

    private String adapter;
    private String procedure;
    private ProgressView progressView;

    /**
     * No progress view will be displayed while the call is being performed for the
     * specified adapter and procedure name.
     *
     * @param adapter the name of the WL adapter
     * @param procedure the name of the WL procedure
     */
    public WLProcedureCaller(String adapter, String procedure) {
        this(adapter, procedure, null);
    }

    /**
     * Will show a progress dialog while the call is being performed for the specified
     * adapter and procedure name.
     *
     * @param adapter the name of the WL adapter
     * @param procedure the name of the WL procedure
     * @param progressView the progress view to be shown while the call is performed
     */
    public WLProcedureCaller(String adapter, String procedure, ProgressView progressView) {
        this.adapter = adapter;
        this.procedure = procedure;
        this.progressView = progressView;
    }

    /**
     * Invokes the specified WL procedure on the specified adapter with the given parameters.
     * The result of the call is passed back to the given WLResponseListener.
     *
     * @param params An array of parameters to be passed with the WL procedure invocation.
     *               Pass null if no parameters are required for the specified procedure.
     * @param responseListener Handles the result of the WL procedure call. May pass null.
     */
    public void invoke(Object params[], final WLResponseListener responseListener) {
        onPreExecute();

        WLProcedureInvocationData invocationData =
                new WLProcedureInvocationData(adapter, procedure, false);
        params = encodeParams(params);
        invocationData.setParameters(params);

        WLClient wlClient = WLClient.getInstance();
        wlClient.invokeProcedure(invocationData, new WLResponseListener() {
            @Override
            public void onSuccess(WLResponse wlResponse) {
                onPostExecute();
                if (responseListener != null) {
                    responseListener.onSuccess(wlResponse);
                }
            }

            @Override
            public void onFailure(WLFailResponse wlFailResponse) {
                Log.e(TAG, wlFailResponse.getErrorMsg());

                onPostExecute();
                if (responseListener != null) {
                    responseListener.onFailure(wlFailResponse);
                }
            }
        }, defaultOptions());
    }

    private void onPreExecute() {
        if (progressView != null) {
            progressView.start();
        }
    }

    private void onPostExecute() {
        if (progressView != null) {
            progressView.stop();
        }
    }

    private Object[] encodeParams(Object[] params) {
        Object encodedParams[] = null;

        if (params != null) {
            encodedParams = new Object[params.length];
            for (int i = 0; i < params.length; i++) {
                Object param = params[i];
                if (param != null && param instanceof String) {
                    encodedParams[i] = Uri.encode((String) param);
                } else {
                    encodedParams[i] = param;
                }
            }
        }

        return encodedParams;
    }

    private static WLRequestOptions options;

    /**
     *
     * @return the default request options for a WL procedure call
     */
    public static WLRequestOptions defaultOptions() {
        if (options == null) {
            options = new WLRequestOptions();
            options.setTimeout(30_000);
        }

        return options;
    }

    private static final String AUTH_REQUIRED_ERROR_MSG =
            "Authentication required to invoke this procedure!";

    public static boolean isAuthenticated(WLResponse response) {
        JSONObject jsonObject = response.getResponseJSON();
        boolean authRequired = jsonObject.optBoolean("authRequired");
        String errorMessage = jsonObject.optString("errorMessage");
        return !(authRequired && errorMessage.equals(AUTH_REQUIRED_ERROR_MSG));
    }

    public interface ProgressView {
        void start();
        void stop();
    }

}
