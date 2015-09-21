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

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public final class AppPropertiesReader {
	// Instance variables
	private static final String fileName = "resources/app.properties";
	public static final Object CREATE_LOCK = new Object();
	// Logger
	private static final Logger LOGGER = Logger.getLogger(AppPropertiesReader.class.getName());

	private static Properties propertyReader;
	static {
		try {
			propertyReader = new Properties();
			InputStream inStream = AppPropertiesReader.class.getClassLoader().getResourceAsStream(
					fileName);
			propertyReader.load(inStream);
		} catch (IOException e) {
			LOGGER.severe("Could not load properties file: " + fileName);
			LOGGER.severe(e.getMessage());
		}
	}

	private AppPropertiesReader() {
		throw new AssertionError("Utilities is non-instantiable");
	}

	public static String getStringProperty(String property) {
		return propertyReader.getProperty(property);
	}

	public static int getIntProperty(String property) {
		return Integer.valueOf(propertyReader.getProperty(property));
	}
}
