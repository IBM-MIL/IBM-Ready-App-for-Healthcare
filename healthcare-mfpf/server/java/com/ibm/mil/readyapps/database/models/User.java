package com.ibm.mil.readyapps.database.models;

import java.util.List;

import com.google.gson.Gson;

public class User extends CloudantObject {
	private String username;
	private String password;
	private String dateOfNextVisit;
	private int visitsUsed;
	private int visitsTotal;
	private int stepGoal;
	private int calorieGoal;
	private List<String> routines;
	private String questionnaire;
	private String userID;
	
	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public String getDateOfNextVisit() {
		return dateOfNextVisit;
	}

	public int getVisitsUsed() {
		return visitsUsed;
	}

	public int getVisitsTotal() {
		return visitsTotal;
	}

	public int getStepGoal() {
		return stepGoal;
	}

	public int getCalorieGoal() {
		return calorieGoal;
	}

	public List<String> getRoutines() {
		return routines;
	}
	
	public String getQuestionnaire() {
		return questionnaire;
	}
	
	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String toString() {
		return new Gson().toJson(this);
	}

}
