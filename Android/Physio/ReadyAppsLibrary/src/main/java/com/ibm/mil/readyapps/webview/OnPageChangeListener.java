/*
 *
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.webview;

import java.util.List;

/**
 * Listen for changes to an @{code MILWebView} widget. To listen for changes to a specific
 * {@code MILWebView}, pass an {@code MILWebViewListener} to its {@code registerListener} method.
 *
 * @see MILWebView
 * @see MILWebView#setOnPageChangeListener(OnPageChangeListener)
 *
 * @author John Petitto
 */
public interface OnPageChangeListener {
    /**
     * Notifies the listener of a page change.
     *
     * @param urlChunks   the url of the new page split into chunks separated by slashes and
     *                    hash marks
     */
    void onPageChange(List<String> urlChunks);
}
