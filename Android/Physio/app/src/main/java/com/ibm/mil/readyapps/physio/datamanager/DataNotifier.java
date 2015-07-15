/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.datamanager;

/**
 * Used to notify a client that that an asynchronous data operation has completed.
 */
public interface DataNotifier {
    /**
     * The asynchronous data operation has completed
     */
    void dataIsAvailable();
}
