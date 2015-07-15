/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.webview;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.Arrays;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * A thin layer over a {@code WebView}. Provides support for detecting and parsing URL schemes
 * typically used with AngularJS ngRoutes. It can be created within an XML layout file or
 * instantiated programmatically. Call {@code launchUrl} with a relative path starting from
 * {@code /assets/html/} to load a page into the {@code WebView}. Call
 * {@code setOnPageChangeListener} to listen for page changes.
 *
 * @see OnPageChangeListener
 *
 * @author John Petitto
 */
public class MILWebView extends WebView {

    private static final String URL_PREFIX = "file:///android_asset/html/";
    private static final Pattern pattern = Pattern.compile("/|#");

    private OnPageChangeListener mListener;

    public MILWebView(Context context, AttributeSet attrs) {
        super(context, attrs);

        // Allows view to render in a visual editor
        if (isInEditMode()) {
            return;
        }

        // MIL specific WebView settings
        getSettings().setJavaScriptEnabled(true);
        getSettings().setDomStorageEnabled(true);
        getSettings().setAllowUniversalAccessFromFileURLs(true);
        getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE); // slight performance optimization

        // Allows JS to invoke native methods via the "MILWebView" object
        addJavascriptInterface(this, "MILWebView");

        // Implement listeners on WebView
        setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                // Inject JS code to notify MILWebView when a hash change occurs in URL
                injectJavaScript("window.onhashchange = function()" +
                        "{ MILWebView.onHashChange(document.URL); };");
                parseUrl(url);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode, String description,
                                        String failingUrl) {
                // Log WebView error to LogCat
                Log.e(MILWebView.class.getName(), "Error received for WebView: " + description);
            }
        });
    }

    /**
     * Listen for pages changes on the @{code MILWebView}.
     *
     * @param listener  the instance that will be notified of page changes
     */
    public void setOnPageChangeListener(OnPageChangeListener listener) {
        mListener = listener;
    }

    /**
     * Loads {@code url} into the {@code WebView}. Prefer this method over the inherited
     * {@code loadUrl} method.
     *
     * @param url   the relative path from /assets/html/
     */
    public void launchUrl(String url) {
        loadUrl(URL_PREFIX + url);
    }

    /**
     * Inject a string representation of JavaScript code into the {@code WebView}. Only call this
     * after being notified in @{code onPageChange} of @{code OnPageChangeListener}.
     *
     * @see OnPageChangeListener#onPageChange(java.util.List)
     *
     * @param code  the JavaScript code to be injected
     */
    public void injectJavaScript(String code) {
        loadUrl("javascript:" + code);
    }

    /**
     * <p>Enable (or disable) @{code WebView} debugging. This only works with <b>API 19+</b>.
     * Note that this is a {@code static} method and will enable/disable debugging for all
     * {@code MILWebView} widgets.</p>
     *
     * <p>For detailed information on debugging, visit
     * <a href="https://developer.chrome.com/devtools/docs/remote-debugging">
     * Remote Debugging on Android with Chrome</a>.</p>
     *
     * @param enable    enable ({@code true}) or disable (@{code false}) debugging
     */
    @TargetApi(Build.VERSION_CODES.KITKAT)
    public static void enableDebugging(boolean enable) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setWebContentsDebuggingEnabled(enable);
        }
    }

    private void parseUrl(String url) {
        // Parse URL only if a OnPageChangeListener has been registered
        if (mListener != null) {
            // Split URL into chunks separated by slashes and hash marks
            mListener.onPageChange(Arrays.asList(pattern.split(url)));
        }
    }

    /**
     * Set the language used to localize text in the {@code WebView}. Only call this after being
     * notified in {@code onPageChange} of {@code OnPageChangeListener}.
     *
     * @see OnPageChangeListener#onPageChange(java.util.List)
     *
     * @param locale    the desired {@code locale} for the {@code WebView} to use when localizing
     *                  text
     */
    public void setLanguage(Locale locale) {
        String localizationCode = getScopeObject();
        localizationCode += "scope.setLanguage('" + locale + "');";
        Log.i(MILWebView.class.getName(), "Localization: " + localizationCode);
        injectJavaScript(localizationCode);
    }

    /**
     * Utility function for initializing the scope object.
     *
     * @return  a snippet of JavaScript code that initializes the variable 'scope' to the
     *          scope object.
     */
    public static String getScopeObject() {
        return "var scope = angular.element(document.getElementById('scope')).scope();";
    }

}
