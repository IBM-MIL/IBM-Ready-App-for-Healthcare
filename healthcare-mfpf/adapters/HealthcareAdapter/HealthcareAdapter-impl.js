/**
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 
 * ReadyAppAdapter interfaces between the client and server. The clients can
 * invoke the adapter procedure and send the correct parameters. The adapter will
 * in turn make a call to the backend server. If the request is successful, the
 * adapter will return true, otherwise it will return false.
 */

/**
 * @class HealthcareAdapter-impl_.js
 * @description HealthcareAdapter implementation files which acts as a mediator between
 * the clients and the backend.
 */
/**
 * return the Singleton instance of the CloudantDBConnector class
 */

var cloudantDBConnector = com.ibm.mil.readyapps.database.CloudantDBConnector.getInstance();

var appRealmName = "SingleStepAuthRealm";
var userLocale;

/**
 * Returns the user object associated with the current user
 * @param username 
 */
function getUserObject(username) {
	return getDataAndParseToJson(function() {
		var user = WL.Server.getActiveUser(appRealmName).userObj;
		WL.Logger.info("getUserObject result: " + user);
		return user;
	});
}

/**
 * Returns the routines assigned for the username
 * @param username
 * @returns routines array or null if user is not authenticated
 */
function getRoutines(username) {
	return getDataAndParseToJson(function() {
		var activeUser = WL.Server.getActiveUser(appRealmName).userObj;
		var result = cloudantDBConnector.getRoutines(activeUser, userLocale);
		WL.Logger.info("getRoutines result: " + result);
		return result;
	});
}

/**
 * Returns the exercises for the assigned routine of the current user 
 * @param routineId
 * @returns exercises array or null if user is not authenticated
 */
function getExercisesForRoutine(routineId) {
	return getDataAndParseToJson(function() {
		var activeUser = WL.Server.getActiveUser(appRealmName).userObj;
		WL.Logger.info("active user: " + activeUser);
		var result = cloudantDBConnector.getExercises(activeUser, userLocale, routineId);
		WL.Logger.info("getExercisesForRoutine result: " + result);
		return result;
	});
}

/**
 * Returns the questionnaire for the user to answer 
 * @param user
 * @returns questions array or null if user is not authenticated
 */
function getQuestionnaireForUser(username) {
	return getDataAndParseToJson(function() {
		var activeUser = WL.Server.getActiveUser(appRealmName).userObj;
		WL.Logger.info("active user: " + activeUser);
		var result = cloudantDBConnector.getQuestionnaire(activeUser, userLocale);
		WL.Logger.info("getQuestionnaireForUser result: " + result);
		return result.questions;
	});
}

/**
 * Ensures the user is properly authenticated. Callback for protected adapter procedures 
 * @param headers
 * @param errorMessage
 * @returns true if user is not authenticated
 */
function onAuthRequired(headers, errorMessage) {
	errorMessage = errorMessage ? errorMessage
			: "Authentication required to invoke this procedure!";

	return {
		authRequired : true,
		errorMessage : errorMessage
	};
}

/**
 * Exposed procedures to authenticate the user on initial login and subsequent logins
 * @param username
 * @param password
 * @returns true/false depending on the credentials provided
 */
function submitAuthentication(username, password, locale) {
	WL.Logger.info("inside submitAuthentication");
	WL.Logger.info("cloudantDBConnector? " + cloudantDBConnector);
	var validUser = cloudantDBConnector.verifyUser(username, password);
	WL.Logger.info("valid user? " + validUser);
	userLocale = locale.split("_")[0]; // remove nationality from locale
	if (validUser) {
		var userIdentity = {
			userId : username,
			userObj : validUser
		};

		WL.Server.setActiveUser(appRealmName, userIdentity);
		
		return {
			isSuccessful : true,
			authRequired : false
		};
	}
	
	return {
		onAuthRequired : onAuthRequired(null, "Invalid login credentials"),
		isSuccessful : false
	};
}

/**
 * Logs out the user due to inactivity or app termination
 */
function onLogout() {
	// TODO
	WL.Logger.info("Logged out");
	WL.Server.setActiveUser(appRealmName, null);
}

function getDataAndParseToJson(callbackFunction) {
	var response = {
		isSuccessful : true
	};

	try {
		var data = callbackFunction();
		response.result = JSON.parse(data);
	} catch (err) {
		response.isSuccessful = false;
		response.errorMsg = err.message;
		// Log error to MFP logs
		WL.Logger.error(err.message);
	}

	return response;
}
