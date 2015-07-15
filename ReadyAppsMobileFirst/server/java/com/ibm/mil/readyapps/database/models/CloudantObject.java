/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.mil.readyapps.database.models;

import com.google.gson.Gson;

/**
 * Pojo that will be the base for each type we are storing as Cloudant
 * documents.
 */
public class CloudantObject {

	private String _id;
	private String type;
	private String _rev;

	/**
	 * constructor for the CloudantObject Sets the instance variables
	 * 
	 * @param toClone
	 */
	public CloudantObject(CloudantObject toClone) {
		super();
		this._id = toClone._id;
		this.type = toClone.type;
		this._rev = toClone._rev;
	}

	/**
	 * default constructor
	 */
	public CloudantObject() {
		super();
	}

	/**
	 * gets the _id field
	 * 
	 * @return _id
	 */
	public String getId() {
		return _id;
	}

	/**
	 * sets the _id field
	 * 
	 * @param _id
	 */
	public void setId(String _id) {
		this._id = _id;
	}

	/**
	 * sets the type for the documents
	 * 
	 * @param type
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * gets the type for the document
	 * 
	 * @return
	 */
	public String getType() {
		return type;
	}

	/**
	 * gets the revision number
	 * 
	 * @return
	 */
	public String get_rev() {
		return _rev;
	}

	/**
	 * sets the revision
	 * 
	 * @param _rev
	 */
	public void set_rev(String _rev) {
		this._rev = _rev;
	}

	/**
	 * converts the data object into a JSON object
	 */
	public String toString() {
		return new Gson().toJson(this);
	}
}
