/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.interfaces;

public interface BackPressHandler {

    /**
     * Prompts the handler that the back button has been pressed, giving it the opportunity to
     * handle the event itself. Implementations of this method should not perform any unnecessary
     * work if it intends to return false to the caller.
     *
     * @return {@code true} if the event is being handled by the receiver, @{code false} otherwise.
     */
    boolean backPressed();

}
