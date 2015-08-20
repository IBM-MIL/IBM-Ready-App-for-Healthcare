/* 
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2015. All
 * Rights Reserved. This sample program is provided AS IS and may be used,
 * executed, copied and modified without royalty payment by customer (a) for its
 * own instruction and study, (b) in order to develop applications designed to
 * run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own
 * products.
 */

package com.ibm.mil.readyapps.database;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.cloudant.client.api.CloudantClient;
import com.cloudant.client.api.Database;
import com.cloudant.client.api.View;
import com.cloudant.client.api.model.Response;
import com.google.gson.Gson;
import com.ibm.mil.readyapps.database.AppPropertiesReader;;

/**
 *
 * This class communicates with Cloudant and returns relevant information for
 * the user who has been properly authenticated. The functions in this class
 * will be invoked via the MobileFirst Platform Adapters.
 */
@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
public final class CloudantService {
	private static CloudantService cloudantConnector;
	private Database db;
	private final Gson gson = new Gson();

	// Logger class for logging output
	private static final Logger LOGGER = Logger.getLogger(CloudantService.class.getSimpleName());

	/*
	 * Private constructor. Instantiates instances of cloudant and the message
	 * services.
	 */
	private CloudantService() {
		super();
		connect();
	}

	/*
	 * Create the connection to the Cloudant database that we'll use for this
	 * service.
	 */
	private void connect() {
		CloudantClient cloudant = new CloudantClient(
				AppPropertiesReader.getStringProperty("CLOUDANT_ACCOUNT"),
				AppPropertiesReader.getStringProperty("CLOUDANT_USERNAME"),
				AppPropertiesReader.getStringProperty("CLOUDANT_PASSWORD"));
		db = cloudant.database(AppPropertiesReader.getStringProperty("CLOUDANT_DB_NAME"), true);
	}

	/**
	 * returns one and only one instance of the CloudantConnector class
	 * 
	 * @return CloudantConnector instance
	 */
	public static CloudantService getInstance() {
		synchronized (CloudantService.class) {
			if (cloudantConnector == null) {
				cloudantConnector = new CloudantService();
			}
		}
		return cloudantConnector;
	}

	/**
	 * getDatabase() returns the cloudant database so that a user can query for
	 * data.
	 * 
	 * @return
	 */
	public Database getDatabase() {
		return db;
	}

	/**
	 * Convenience method for deleting all document records from the database
	 * except design documents.
	 */
	private void deleteRecords() {
		List<Map> results = db.view("_all_docs").includeDocs(true).query(Map.class);
		int recordsDeleted = 0;
		for (Map record : results) {
			String id = (String) record.get("_id");
			// Delete record only if it is not a design document
			if (!id.startsWith("_design/")) {
				Response response = db.remove(record);
				id = response.getId();
				LOGGER.info("Record with the following _id was deleted: " + id);
				recordsDeleted++;
			}
		}
		LOGGER.info("Number of records to deleted: " + recordsDeleted);
	}

	private List<Map> getMapCollection(String viewName, Object[] startKeys, Object... endKeys) {

		// Get reference to corresponding view on Cloudant databasea
		View view = db.view(
				AppPropertiesReader.getStringProperty("physio_design_doc/" + viewName))
				.includeDocs(true);

		// Apply filters (if any)
		if (startKeys != null) {
			view.startKey(startKeys);
		}
		if (endKeys != null) {
			view.endKey(endKeys);
		}

		return view.query(Map.class);
	}

	/**
	 * Convenience method for filtering a Cloudant view by record ID.
	 * 
	 * @param viewName
	 * @param clazz
	 * @param id
	 * @return
	 */
	private <T extends List<U>, U> T getCollection(String viewName, Class<U> clazz, String... id) {

		// Key filters for view
		Object[] startKey = null;
		Object[] endKey = null;

		if (id.length == 1) {
			startKey = new Object[] { id[0] };
			endKey = new Object[] { id[0] };
		}

		return getCollection(viewName, clazz, startKey, endKey);
	}

	/**
	 * This method provides a work around to address an issue that exists today
	 * in the Cloudant/CouchDB library: there is no way to configure the Gson
	 * instance that is used when reading data from the cloudant db. Because of
	 * this, the current library cannot handle timestamp values that are stored
	 * in the following format: "yyyy-MM-dd'T'HH:mm:ss".
	 * 
	 * @param viewName
	 * @param clazz
	 * @param id
	 * @return
	 */
	private <T extends List<U>, U> T getCollection(String viewName, Class<U> clazz,
			Object[] startKey, Object... endKey) {

		List<Map> results = getMapCollection(viewName, startKey, endKey);
		T collection = (T) new ArrayList<U>(results.size());
		for (Map record : results) {
			String jsonStr = gson.toJson(record);
			U object = gson.fromJson(jsonStr, clazz);
			collection.add(object);
		}
		return collection;
	}

}