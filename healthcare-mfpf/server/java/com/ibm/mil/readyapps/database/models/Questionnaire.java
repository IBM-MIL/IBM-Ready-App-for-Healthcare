package com.ibm.mil.readyapps.database.models;

import java.util.List;

import com.google.gson.Gson;

public class Questionnaire extends LocalizedObject {
	List<Question> questions;
	
	public List<Question> getQuestions() {
		return questions;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}

}
