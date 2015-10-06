/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.models;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class Patient {

    private static final String USER_ID = "userID";
    private static final String DATE_OF_NEXT_VISIT = "dateOfNextVisit";
    private static final String VISITS_USED = "visitsUsed";
    private static final String VISITS_TOTAL = "visitsTotal";
    private static final String STEPS_GOAL = "stepGoal";
    private static final String CALORIES_GOAL = "calorieGoal";

    private String userID;
    private Date dateOfNextVisit;
    private Integer visitsUsed;
    private Integer visitsTotal;
    private Integer stepGoal;
    private Integer calorieGoal;

    private List<Form> formList;
    private List<Routine> routineList;
    private Map<Routine, List<Exercise>> exerciseMap;
    private int exerciseSets = 0;

    private Routine selectedRoutine;
    private Exercise selectedExercise;

    /**
     * Initializes a Patient object with the data returned from Worklight
     *
     * @param jsonResp The JSONObject from Worklight
     */
    public Patient(JSONObject jsonResp) {
        try {
            String stringResult = jsonResp.getString("result");
            JSONObject jsonResult = new JSONObject(stringResult);

            this.setUserID(jsonResult.getString(USER_ID));
            this.visitsUsed = jsonResult.getInt(VISITS_USED);
            this.visitsTotal = jsonResult.getInt(VISITS_TOTAL);
            this.stepGoal = jsonResult.getInt(STEPS_GOAL);
            this.calorieGoal = jsonResult.getInt(CALORIES_GOAL);
            String dateOfNextVisitString = jsonResult.getString(DATE_OF_NEXT_VISIT);
            this.dateOfNextVisit = new SimpleDateFormat("MM/dd/yyyy", Locale.ENGLISH)
                    .parse(dateOfNextVisitString);
            formList = new ArrayList<>();
            routineList = new ArrayList<>();
            exerciseMap = new HashMap<>();
        } catch (JSONException|ParseException e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets the userID of the Patient.
     *
     * @return String userID
     */
    public String getUserID() {
        return this.userID;
    }

    /**
     * Sets the userID of a Patient.
     *
     * @param userID
     */
    public void setUserID(String userID) {
        this.userID = (userID != null) ? userID : "";
    }


    /**
     * Gets the date of the next visit for the Patient.
     *
     * @return Date dateOfNextVisit
     */
    public Date getDateOfNextVisit() {
        return this.dateOfNextVisit;
    }


    /**
     * Gets the number of visits the Patient has used.
     *
     * @return Integer visitsUsed
     */
    public Integer getVisitsUsed() {
        return this.visitsUsed;
    }


    /**
     * Gets the total number of visits the Patient has.
     *
     * @return Integer visitsTotal
     */
    public Integer getVisitsTotal() {
        return this.visitsTotal;
    }

    /**
     * The step goal for the patient.
     *
     * @return Integer stepGoal
     */
    public Integer getStepGoal() {
        return this.stepGoal;
    }


    /**
     * The calorie goal for the patient.
     *
     * @return Integer calorieGoal
     */
    public Integer getCalorieGoal() {
        return this.calorieGoal;
    }

    /**
     *
     * @param formList A list of form questions associated with the patient
     */
    public void setForms(List<Form> formList) {
        this.formList = formList;
    }

    /**
     *
     * @return A list of form questions associated with the patient
     */
    public List<Form> getForms() {
        return formList;
    }

    /**
     *
     * @param routineList A list of routines associated with the patient
     */
    public void setRoutines(List<Routine> routineList) {
        this.routineList = routineList;
    }

    /**
     *
     * @return A list of routines associated with the patient
     */
    public List<Routine> getRoutines() {
        return routineList;
    }

    /**
     *
     * @param routine The routine that the exercises fall under
     * @param exerciseList The list of exercises for the specified routine
     */
    public void addExercises(Routine routine, List<Exercise> exerciseList) {
        exerciseMap.put(routine, exerciseList);
        exerciseSets++;
    }

    /**
     *
     * @param routine The routine that the desired exercises belong to
     * @return The list of exercises for the specified routine
     */
    public List<Exercise> getExercises(Routine routine) {
        return exerciseMap.get(exerciseMap.keySet().iterator().next());
    }

    /**
     *
     * @param routine The routine selected by the user in the RoutineFragment
     */
    public void setSelectedRoutine(Routine routine) {
        selectedRoutine = routine;
    }

    /**
     *
     * @return The routine selected by the user in the RoutineFragment
     */
    public Routine getSelectedRoutine() {
        return selectedRoutine;
    }

    /**
     *
     * @param exercise The exercise selected by the user in the ExerciseFragment
     */
    public void setSelectedExercise(Exercise exercise) {
        selectedExercise = exercise;
    }

    /**
     *
     * @return The exercise selected by the user in the ExerciseFragment
     */
    public Exercise getSelectedExercise() {
        return selectedExercise;
    }

    /**
     *
     * @return The number of Routines that contain exercises
     */
    public int getNumberOfExerciseSets() {
        return exerciseSets;
    }

}
