/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.models;

import org.json.JSONException;
import org.json.JSONObject;

public class Form {

    private static final String ID = "_id";
    private static final String TEXT_DESCRIPTION = "text";
    private static final String TYPE = "type";

    private String id;
    private String description;
    private String type;

    /**
     * Initializes a Forms object with the data returned from Worklight
     *
     * @param jsonResult The JSONObject from Worklight
     */
    public Form(JSONObject jsonResult) {
        try {
            this.id = jsonResult.getString(ID);
            this.description = jsonResult.getString(TEXT_DESCRIPTION);
            this.type = jsonResult.getString(TYPE);

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets the id of the Form.
     *
     * @return id
     */
    public String getId() {

        return this.id;
    }

    /**
     * Gets the text of the Form.
     *
     * @return description
     */
    public String getTextDescription() {

        return this.description;
    }


    /**
     * Gets the type of the form.
     *
     * @return type
     */
    public String getType() {

        return this.type;
    }

}