
/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.utils;

import java.util.Locale;

/**
 * A small utility class for determining if a locale uses Imperial or Metric units of measurement.
 * This code was derived from the following answer on stackoverflow.com:
 * http://stackoverflow.com/a/7860788/3761521.
 */
public class UnitLocale {
    public static UnitLocale Imperial = new UnitLocale();
    public static UnitLocale Metric = new UnitLocale();

    private UnitLocale() {
        // class is non-instantiable from outside the class
        // use getDefault() and getFrom() instead
    }

    /**
     * While this method returns the unit of measurement for the system's default locale, this may
     * not be accurate if the user has changed their locale while the app is running. It is better
     * to call getFrom(Locale locale) directly, passing it getResources().getConfiguration().locale
     * from the appropriate Context.
     *
     * @return The unit of measurement for the default locale
     */
    public static UnitLocale getDefault() {
        return getFrom(Locale.getDefault());
    }

    /**
     *
     * @param locale The locale used to determine the unit of measurement
     * @return The unit of measurement for the specified locale
     */
    public static UnitLocale getFrom(Locale locale) {
        switch (locale.getCountry()) {
            case "US": // USA
            case "LR": // Liberia
            case "MM": // Burma
                return Imperial;
            default:
                return Metric;
        }
    }

}
