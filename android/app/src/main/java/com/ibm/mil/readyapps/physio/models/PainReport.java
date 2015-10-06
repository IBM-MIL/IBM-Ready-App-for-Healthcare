/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.models;

import java.util.Date;

import io.realm.RealmObject;

/**
 * A class for serializing and de-serializing locally persisted pain report data with Realm.
 */
public class PainReport extends RealmObject {
    private Date date;
    private int painAmount;
    private String description;

    /**
     *
     * @param date The date when the pain report was submitted
     */
    public void setDate(Date date) {
        this.date = date;
    }

    /**
     *
     * @return The date when the pain report was submitted
     */
    public Date getDate() {
        return date;
    }

    /**
     *
     * @param painAmount The amount of pain (0-10) reported by the user in the pain report
     */
    public void setPainAmount(int painAmount) {
        this.painAmount = painAmount;
    }

    /**
     *
     * @return The amount of pain (0-10) reported by the user in the pain report
     */
    public int getPainAmount() {
        return painAmount;
    }

    /**
     *
     * @param description The description entered by the user in the pain report describing the
     *                    pain
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     *
     * @return The pain description entered by the user in the pain report describing the pain
     */
    public String getDescription() {
        return description;
    }

}
