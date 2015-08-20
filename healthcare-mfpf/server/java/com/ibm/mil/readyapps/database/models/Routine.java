package com.ibm.mil.readyapps.database.models;

import java.util.List;

import com.google.gson.Gson;

public class Routine extends LocalizedObject {
	private String routineTitle;
	private List<Exercise> exercises;
	
	public String getTitle() {
		return routineTitle;
	}
	
	public List<Exercise> getExercises() {
		return exercises;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}
	
}
