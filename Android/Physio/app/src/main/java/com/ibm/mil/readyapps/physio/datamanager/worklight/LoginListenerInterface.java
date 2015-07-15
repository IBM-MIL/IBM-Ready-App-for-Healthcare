/*
* Licensed Materials - Property of IBM
* © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

package com.ibm.mil.readyapps.physio.datamanager.worklight;

public interface LoginListenerInterface {

    void handleLogin(ResultType type);

    /**
     * The result of a login attempt
     */
    public enum ResultType {
        SUCCESS,
        FAILURE
    }

}
