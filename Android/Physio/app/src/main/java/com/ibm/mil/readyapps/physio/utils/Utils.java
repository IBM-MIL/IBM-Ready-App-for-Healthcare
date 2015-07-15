/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.utils;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * A collection of general purpose utility functions.
 */
public class Utils {

    /**
     * Returns a string representation of the date object based on the given locale, which is
     * formatted to show only the month and day (e.g. 01/01 for January 1).
     *
     * @param date   the date to be formatted
     * @param locale the locale of the user
     * @return a string representation of the date object in the given locale, showing only the
     * month and day
     */
    public static String localizedDateWithoutYear(Date date, Locale locale) {
        String formattedString = DateFormat.getDateInstance(DateFormat.SHORT, locale).format(date);

        boolean firstSlash = false;
        for (int i = 0; i < formattedString.length(); i++) {
            if (formattedString.charAt(i) == '/') {
                if (firstSlash) {
                    formattedString = formattedString.substring(0, i);
                    break;
                } else {
                    firstSlash = true;
                }
            }
        }

        return formattedString;
    }

    /**
     * Converts the string representation of a number (both integer and floating point values) to
     * a string containing the number as an integer with the necessary number of leading zeros to
     * match the desired width.
     * <p/>
     * <p>Examples:
     * <ul>
     * <li>number: 3.14, width: 3 -> 003</li>
     * <li>number: 3, width: 2 -> 03</li>
     * <li>number: 3.14159, width: 1 -> 3</li>
     * </ul>
     * </p>
     *
     * @param number the string representation of a number (integer or floating point)
     * @param width  the desired width of the number, including any leading zeros
     * @return a string representation of the number as an integer value with the necessary
     * number of leading zeros to match the desired width
     */
    public static String zeroPaddedNumber(String number, int width) {
        int rawNumber = (int) Double.parseDouble(number);
        return String.format("%0" + width + "d", rawNumber);
    }

    /**
     * @param values a list of integers
     * @return the average value of the integers in the list
     */
    public static int average(List<Integer> values) {
        if (values.size() == 0) {
            return 0;
        }

        int sum = 0;
        for (Integer value : values) {
            sum += value;
        }

        return sum / values.size();
    }

    /**
     * @param values a list of integers
     * @return the sum of the integers in the list
     */
    public static int sum(List<Integer> values) {
        int sum = 0;
        for (Integer value : values) {
            sum += value;
        }
        return sum;
    }

    /**
     * @param values a non-empty list of integers
     * @return the minimum value in the list
     */
    public static int min(List<Integer> values) {
        int min = values.get(0);
        for (Integer value : values) {
            if (value < min) {
                min = value;
            }
        }
        return min;
    }

    /**
     * @param values a non-empty list of integers
     * @return the maximum value in the list
     */
    public static int max(List<Integer> values) {
        int max = values.get(0);
        for (Integer value : values) {
            if (value > max) {
                max = value;
            }
        }
        return max;
    }

}
