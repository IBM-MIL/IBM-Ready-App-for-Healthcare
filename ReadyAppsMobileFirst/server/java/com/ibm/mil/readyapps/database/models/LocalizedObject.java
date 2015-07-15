package com.ibm.mil.readyapps.database.models;

import com.google.gson.Gson;

public class LocalizedObject extends CloudantObject {
	private String category;
	private String locale;
	
	public String getCategory() {
		return category;
	}
	
	public String getLocale() {
		return locale;
	}
	
	public String toString() {
		return new Gson().toJson(this);
	}
}
