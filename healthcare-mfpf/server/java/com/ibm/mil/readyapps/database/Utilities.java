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

import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.ibm.mil.readyapps.database.AppPropertiesReader;

public final class Utilities {
	private static final Logger LOGGER = Logger.getLogger(Utilities.class.getSimpleName());

	private Utilities() {
		throw new AssertionError("Utilities is non-instantiable");
	}

	private enum IllegalArgs {
		SPACE(" "), SHOW("show"), UPDATE("update"), DB("db"), INSERT("insert"), SAVE("save"), REMOVE(
				"remove"), DROP("drop"), COLLECTION("collection");

		private final String illegalArg;

		IllegalArgs(String illegalArg) {
			this.illegalArg = illegalArg;
		}

		public String getIllegalArg() {
			return illegalArg;
		}
	}

	public static boolean isSanitary(String argument) {
		return isSanitary(argument, AppPropertiesReader.getStringProperty("DEFAULT_LOCALE"));
	}

	/**
	 * Ensures that some sanity checking is done against the arguments passed in
	 * from the client to the back end. This method returns false if one of the
	 * "bad" strings is found, basically checking for sql injections, etc.
	 * 
	 * @param argument
	 *            The parameter passed in from the client
	 * @param locale
	 *            The locale of the client user
	 * @return True if the client argument is sanitary, or false if it contains
	 *         basd strings.
	 */
	public static boolean isSanitary(String argument, String locale) {
		boolean sanitary = true;
		// check for null, empty, sql query, etc
		try {
			String lowered = argument == null ? null : argument.toLowerCase(new Locale(locale));
			boolean throwsException = false;

			if (argument == null) {
				throwsException = true;
			} else if (argument.length() == 0) {
				throwsException = true;
			} else {
				for (IllegalArgs arg : IllegalArgs.values()) {
					if (lowered.contains(arg.getIllegalArg())) {
						throwsException = true;
						break;
					}
				}
			}
			if (throwsException) {
				throw new IllegalArgumentException("input is not sanitary");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			LOGGER.log(Level.SEVERE, "input is not sanitary");
			sanitary = false;
		}

		return sanitary;
	}

}
