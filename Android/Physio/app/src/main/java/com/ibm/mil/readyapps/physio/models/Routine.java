/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.models;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Routine {

    private static final String ID = "_id";
    private static final String ROUTINE_TITLE = "routineTitle";
    private static final String EXERCISES = "exercises";

    private String id;
    private String routineTitle;
    private JSONArray exercises;

    /**
     * Initializes a Routine object with the data returned from Worklight
     *
     * @param jsonResult The JSONObject from Worklight
     */
    public Routine(JSONObject jsonResult) {
        try {
            this.id = jsonResult.getString(ID);
            this.routineTitle = jsonResult.getString(ROUTINE_TITLE);
            this.exercises = jsonResult.getJSONArray(EXERCISES);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets the id of the Routine.
     *
     * @return String id
     */
    public String getId() {

        return this.id;
    }

    /**
     * Gets the title of the Routine.
     *
     * @return String routineTitle
     */
    public String getRoutineTitle() {
        return this.routineTitle;
    }

    /**
     * Gets the exercises that belong to the routine.
     *
     * @return JSONArray exercises
     */
    public JSONArray getExercises() {
        return this.exercises;
    }

}

