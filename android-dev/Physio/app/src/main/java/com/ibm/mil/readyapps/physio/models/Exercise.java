/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.models;

import org.json.JSONException;
import org.json.JSONObject;

public class Exercise {

    private static final String ID = "_id";
    private static final String EXERCISE_TITLE = "exerciseTitle";
    private static final String EXERCISE_DESCRIPTION = "description";
    private static final String MINUTES = "minutes";
    private static final String REPETITIONS = "repetitions";
    private static final String SETS = "sets";
    private static final String URL = "url";
    private static final String TOOLS = "tools";

    private String id;
    private String exerciseTitle;
    private String description;
    private String minutes;
    private String repetitions;
    private String sets;
    private String url;
    private String tools;

    /**
     * Initializes an Exercise object with the data returned from Worklight
     *
     * @param jsonResult The JSONObject from Worklight
     */
    public Exercise(JSONObject jsonResult) {
        try {
            this.id = jsonResult.getString(ID);
            this.exerciseTitle = jsonResult.getString(EXERCISE_TITLE);
            this.description = jsonResult.getString(EXERCISE_DESCRIPTION);
            this.minutes = jsonResult.getString(MINUTES);
            this.repetitions = jsonResult.getString(REPETITIONS);
            this.sets = jsonResult.getString(SETS);
            this.url = jsonResult.getString(URL);
            this.tools = jsonResult.getString(TOOLS);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets the id of the Exercise.
     *
     * @return id
     */
    public String getId() {
        return this.id;
    }

    /**
     * Gets the title of the Exercise.
     *
     * @return routineTitle
     */
    public String getExerciseTitle() {
        return this.exerciseTitle;
    }


    /**
     * Gets the description of the Exercise.
     *
     * @return description
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Gets the minutes of how long the Exercise will last.
     *
     * @return description
     */
    public String getMinutes() {
        return this.minutes;
    }

    /**
     * Gets the total number repetitions of the Exercise.
     *
     * @return repetitions
     */
    public String getRepetitions() {
        return this.repetitions;
    }

    /**
     * Gets the total number sets of the Exercise.
     *
     * @return sets
     */
    public String getSets() {
        return this.sets;
    }

    /**
     * Gets the url to the video of the Exercise.
     *
     * @return url
     */
    public String getUrl() {
        return this.url;
    }

    /**
     * Gets the tools required to complete the Exercise.
     *
     * @return tools
     */
    public String getTools() {
        return this.tools;
    }

}