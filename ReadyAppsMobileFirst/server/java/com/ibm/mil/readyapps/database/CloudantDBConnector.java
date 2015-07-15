/**
 * Licensed Materials - Property of IBM © Copyright IBM Corporation 2014. All
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
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.ibm.mil.readyapps.database.models.Exercise;
import com.ibm.mil.readyapps.database.models.Questionnaire;
import com.ibm.mil.readyapps.database.models.Routine;
import com.ibm.mil.readyapps.database.models.User;

/**
 * Responsible for querying the Cloudant database directly via the Cloudant Java API.
 * The public facing methods defined here are typically invoked by a MobileFirst
 * Platform (MFP) adapter.
 * 
 * Note: This class is not designed for extension and thus has been marked as final.
 * 
 * @author jpetitt
 */
public final class CloudantDBConnector {
	private static final Logger LOGGER = Logger.getLogger(CloudantDBConnector.class.getSimpleName());
	
	private static CloudantDBConnector connector;
	private final CloudantService service;
	private final Gson gson;
	
	/**
	 * Returns a single instance of the CloudantDBConnector class. Synchronization is in
	 * place in order to ensure only one instance is ever created. Due to the class's
	 * constructor being overridden and marked as private, this is the only way to
	 * instantiate the class.
	 * 
	 * @return a single instance of CloudantDBConnector
	 */
	public static CloudantDBConnector getInstance() {
		synchronized(CloudantDBConnector.class) {
			if (connector == null) {
				connector = new CloudantDBConnector();
			}
		}
		return connector;
	}
	
	private CloudantDBConnector() {
		service = CloudantService.getInstance();
		gson = new Gson();
	}
	
	/**
	 * verifyUser() gets the User object associated with the username and then
	 * returns the user if the password is valid, if the username is invalid or
	 * the password is invalid, then verifyUser returns null;
	 * 
	 * @param username
	 *            the username of the user to verify.
	 * @param password
	 *            the password of the user to verify.
	 * @return retUser valid username and password : retUser is the User object
	 *         associated with the now verified user. invalid username or
	 *         password : retUser is null.
	 * 
	 */
	public User verifyUser(String username, String password) {
		LOGGER.log(Level.INFO, "entering verified user");
		
		// Sanity check for: null, empty, sql query, etc
		boolean sanityVerificationforUsername = Utilities.isSanitary(username);
		boolean sanityVerificationforPassword = Utilities.isSanitary(password);

		User retUser = null;
		if (sanityVerificationforUsername && sanityVerificationforPassword) {
			User user = getUser(username);

			// check if the query returned a user (null check)
			// if a user is returned, then validate the password for the user.
			if (user != null && validateUserPassword(user, password)) {
				retUser = user;
				retUser.setUserID(user.getId());
			}
		}
		
		LOGGER.log(Level.INFO, "valid user: " + retUser);
		
		return retUser;
	}
	
	/**
	 * Fetches the User for the specified username if one exists, returns null
	 * otherwise. This method is provided as a convenience, but typically
	 * invoking verifyUser() will suffice.
	 * 
	 * @param username
	 * @return the User associated with the given username, null otherwise
	 */
	public User getUser(String username) {
		User user = null;

		List<User> users = service.getDatabase()
				.view("physio_design_doc/users")
				.key(username)
				.includeDocs(true)
				.query(User.class);
		
		if (users != null && !users.isEmpty()) {
			user = users.get(0);
			user.setUserID(user.getId());
		}
		
		return user;
	}
	
	private boolean validateUserPassword(User u1, String password) {
		return u1.getPassword() != null && u1.getPassword().equals(password);
	}
	
	/**
	 * Collects all routines for a given user in the desired locale.
	 * If no routines are found, an empty list is returned.
	 * 
	 * @param user
	 * @param locale
	 * @return A list containing zero or more Routine objects associated with
	 * the specified user and the given locale.
	 */
	public List<Routine> getRoutines(User user, String locale) {
		List<Routine> userRoutines = new ArrayList<>();
		
		List<String> routineCategories = user.getRoutines();
		for (String category : routineCategories) {
			List<Routine> routines = service.getDatabase()
					.view("physio_design_doc/routines")
					.key(category, locale)
					.includeDocs(true)
					.query(Routine.class);
			
			if (routines != null) {
				userRoutines.addAll(routines);
			}
		}
		
		return userRoutines;
	}
	
	/**
	 * Returns the list of exercises associated with the given routine id
	 * and locale. If no routine is found for the specified id, then null
	 * is returned. Otherwise, a list of zero or more exercises is returned.
	 * 
	 * @param user
	 * @param locale
	 * @param routineId
	 * @return A list of zero or more exercises. If a routine does not exist
	 * for the specified id, then null is returned.
	 */
	public List<Exercise> getExercises(User user, String locale, String routineId) {
		List<Routine> routines = getRoutines(user, locale);
		
		if (routines != null && !routines.isEmpty()) {
			return routines.get(0).getExercises();
		} else {
			return null;
		}
	}
	
	/**
	 * Returns the Questionnaire for the associated User and locale.
	 * If no questionnaire exists, null is returned.
	 * 
	 * @param user
	 * @param locale
	 * @return The questionnaire for the associated User and locale.
	 * Null is returned if no questionnaire exists.
	 */
	public Questionnaire getQuestionnaire(User user, String locale) {
		LOGGER.log(Level.INFO, "user: " + user);
		
		String questionnaireCategory = user.getQuestionnaire();
		LOGGER.log(Level.INFO, "questionnaire category: " + questionnaireCategory);
		List<Questionnaire> questionnaires = service.getDatabase()
				.view("physio_design_doc/questionnaires")
				.key(questionnaireCategory, locale)
				.includeDocs(true)
				.query(Questionnaire.class);
		
		LOGGER.log(Level.INFO, "questionnaire result: " + questionnaires);
		
		if (questionnaires != null && !questionnaires.isEmpty()) {
			LOGGER.log(Level.INFO, "is valid questionnaire!");
			return questionnaires.get(0);
		} else {
			return null; // no questionnaire found for given user
		}
	}
	
	public static void main(String[] args) {
		CloudantDBConnector connector = CloudantDBConnector.getInstance();
		
		// test getUser()
		User user = connector.getUser("user1");
		System.out.println("User: " + user);
		
		// test verifyUser()
		User verifiedUser = connector.verifyUser("user1", "password1");
		System.out.println("Verified user: " + verifiedUser);
		
		// test getRoutines()
		List<Routine> routines = connector.getRoutines(user, "en");
		System.out.println("Routines: " + routines);
		
		// test getExercises()
		String routineId = routines.get(0).getId();
		List<Exercise> exercises = connector.getExercises(user, "en", routineId);
		System.out.println("Exercises: " + exercises);
		
		// test getQuestionnaire()
		Questionnaire questionnaire = connector.getQuestionnaire(user, "en");
		System.out.println("Questionnaire: " + questionnaire);
	}
	
}
