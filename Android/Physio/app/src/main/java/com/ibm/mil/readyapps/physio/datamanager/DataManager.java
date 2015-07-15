/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.datamanager;

import com.ibm.mil.readyapps.physio.models.Patient;

/**
 * Data Manager is a wrapper to the database connection
 */
public class DataManager {

    private static Patient currentPatient;
    private static DataManager instance;

    private DataManager() {
        // non-instantiable, use getInstance()
    }

    /**
     * Class function that will return a singleton when requested
     *
     * @return The instance of the DataManager
     */
    public static DataManager getInstance() {
        if (instance == null) {
            instance = new DataManager();
        }
        return instance;
    }

    /**
     * Used to get the instance of the patient that is logged into the application.
     *
     * @return A Patient object
     */
    public static Patient getCurrentPatient() {
        return currentPatient;
    }

    /**
     * Sets the current Patient object
     *
     * @param currentPatient the current Patient
     */
    public void setCurrentPatient(Patient currentPatient) {
        this.currentPatient = currentPatient;
    }

}