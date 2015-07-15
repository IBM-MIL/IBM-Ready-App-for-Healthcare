/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.utils;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Vibrator;
import android.util.TypedValue;
import android.view.Window;

import com.ibm.mil.readyapps.physio.R;

/**
 * A collection of utility functions for Android
 */
public class AndroidUtils {

    /**
     * The default vibration length for the phone
     */
    public static long DEFAULT_VIBRATE_LENGTH = 500;

    private AndroidUtils() {
        throw new AssertionError("AndroidUtils is non-instantiable");
    }

    /**
     *
     * @param context
     * @return The custom Typeface for RobotoSlab-Bold.ttf
     */
    public static Typeface robotoBold(Context context) {
        return Typeface.createFromAsset(context.getAssets(), "fonts/RobotoSlab-Bold.ttf");
    }

    /**
     *
     * @param context
     * @return The custom Typeface for RobotoSlab-Light.ttf
     */
    public static Typeface robotoThin(Context context) {
        return Typeface.createFromAsset(context.getAssets(), "fonts/RobotoSlab-Light.ttf");
    }

    /**
     *
     * @param context
     * @return The custom Typeface for RobotoSlab-Regular.ttf
     */
    public static Typeface robotoRegular(Context context) {
        return Typeface.createFromAsset(context.getAssets(), "fonts/RobotoSlab-Regular.ttf");
    }

    /**
     * Vibrates the phone for the desired number of milliseconds. Ensure that the vibration
     * permission is listed in the app's manifest file.
     *
     * @param context
     * @param milliseconds The number of milliseconds to vibrate the phone for
     */
    public static void vibratePhone(Context context, long milliseconds) {
        Vibrator vibrator = (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);
        vibrator.vibrate(milliseconds);
    }

    /**
     * A dialog that contains only the animating circular progress icon. Simply call show() on
     * the returned dialog object. Call dismiss() to hide or cancel() to destroy the dialog object.
     *
     * @param context
     * @return The custom dialog object
     */
    public static Dialog circularProgressDialog(Context context) {
        Dialog dialog = new Dialog(context);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.progress_dialog_custom);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        dialog.setCancelable(false);
        return dialog;
    }

    /**
     * Changes the status bar color. This only works on API 21+.
     *
     * @param window The window of the Activity
     * @param color The desired color (resource ID) for the status bar
     */
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public static void statusBarColor(Window window, int color) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.setStatusBarColor(color);
        }
    }

    /**
     * Removes the action bar from the activity. This only works on API 11+.
     *
     * @param activity
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public static void removeActionBar(Activity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            activity.getWindow().requestFeature(Window.FEATURE_ACTION_BAR);
            activity.getActionBar().hide();
        }
    }

    /**
     * Converts pixels to density-independent pixels (dip).
     *
     * @param context
     * @param pixels
     * @return the converted number of pixels based on the display metrics
     */
    public static int pixelsToDip(Context context, int pixels) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                pixels, context.getResources().getDisplayMetrics());
    }

    /**
     *
     * @param context
     * @return the height of the status bar
     */
    public static int getStatusBarHeight(Context context) {
        int result = 0;
        int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = context.getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    /**
     * Creates a string representation of the number with the appropriate localized number suffix
     * (e.g. st, nd, rd, th).
     *
     * @param context
     * @param number
     * @return A string representation of the number with the appropriate localized number suffix
     */
    public static String numberSuffixLocalized(Context context, int number) {
        if (number >= 11 && number <= 13) {
            return context.getString(R.string.th);
        }

        switch (number % 10) {
            case 1:
                return context.getString(R.string.st);
            case 2:
                return context.getString(R.string.nd);
            case 3:
                return context.getString(R.string.rd);
            default:
                return context.getString(R.string.th);
        }
    }

}
