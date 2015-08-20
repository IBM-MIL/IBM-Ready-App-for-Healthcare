package com.ibm.mil.readyapps.database.models;

import com.google.gson.Gson;

public class Exercise {
	private String _id;
	private String exerciseTitle;
	private String description;
	private String tools;
	private int minutes;
	private int repetitions;
	private int sets;
	private String url;
	
	public String getId() {
		return _id;
	}
	
	public String getTitle() {
		return exerciseTitle;
	}
	
	public String getDescription() {
		return description;
	}
	
	public String getTools() {
		return tools;
	}
	
	public int getMinutes() {
		return minutes;
	}
	
	public int getRepetitions() {
		return repetitions;
	}
	
	public int getSets() {
		return sets;
	}
	
	public String getUrl() {
		return url;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}
	
}
