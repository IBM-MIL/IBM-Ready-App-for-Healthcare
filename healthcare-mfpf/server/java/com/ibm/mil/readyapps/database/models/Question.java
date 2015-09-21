package com.ibm.mil.readyapps.database.models;

import com.google.gson.Gson;

public class Question {
	private String _id;
	private String text;
	
	public String getId() {
		return _id;
	}
	
	public String getText() {
		return text;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}
	
}
