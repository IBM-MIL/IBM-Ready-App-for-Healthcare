/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.activities;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
//import android.util.Log;
import com.apphance.android.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.common.api.GoogleApiClient;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.datamanager.DataNotifier;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataInjector;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataRetriever;
import com.ibm.mil.readyapps.physio.datamanager.worklight.ReadyAppsChallengeHandler;
import com.ibm.mil.readyapps.physio.fragments.ProgressFragment;
import com.ibm.mil.readyapps.physio.models.Exercise;
import com.ibm.mil.readyapps.physio.models.Form;
import com.ibm.mil.readyapps.physio.models.Patient;
import com.ibm.mil.readyapps.physio.models.Routine;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.WLProcedureCaller;
import com.ibm.mil.readyapps.physio.views.PhysioAlertDialog;
import com.ibm.mil.readyapps.physio.views.PhysioDialog;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

//MQA Imports
import com.apphance.android.Apphance;
import com.apphance.android.Apphance.Mode;
import com.apphance.android.common.Configuration;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

/**
 * The first activity that appears when the user launches the app. After a valid
 * login is submitted the user can no longer return to the LoginActivity via the device's back
 * button. A valid login sends the user to the LandingActivity.
 *
 * @see com.ibm.mil.readyapps.physio.activities.LandingActivity
 */
public class LoginActivity extends Activity implements DataNotifier {
    private static final String TAG = LoginActivity.class.getName();
    public static final String APP_KEY = "4f69d7662c78a5291250fba8f603767d2ec871fb";

    private EditText mPatientText;
    private EditText mPasswordText;
    private Dialog mProgressDialog;
    private GoogleApiClient fitClient;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        Configuration configuration = new Configuration.Builder(this)
                .withAPIKey(APP_KEY)
                .withMode(Mode.QA)
                .withReportOnShakeEnabled(true)
                .build();

        Apphance.startNewSession(LoginActivity.this, configuration);

        fitClient = HealthDataRetriever.getClient(this);
        if (!fitClient.isConnected()) {
            fitClient.connect();
        }

        mPatientText = (EditText) findViewById(R.id.patient_id);
        mPasswordText = (EditText) findViewById(R.id.password);
        Button loginButton = (Button) findViewById(R.id.login_button);
        TextView loginTitle = (TextView) findViewById(R.id.login_title);

        mProgressDialog = AndroidUtils.circularProgressDialog(this);

        // set custom type faces for necessary views
        Typeface robotoThin = AndroidUtils.robotoThin(this);
        Typeface robotoBold = AndroidUtils.robotoBold(this);
        mPatientText.setTypeface(robotoThin);
        mPasswordText.setTypeface(robotoThin);
        loginButton.setTypeface(robotoThin);
        loginTitle.setTypeface(robotoBold);

        // route soft keyboard login completion to submitLogin listener
        mPasswordText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    submitLogin(v);
                    handled = true;
                }
                return handled;
            }
        });

        // connect to WL and register challenge handler for authentication
        WLClient wlClient = WLClient.createInstance(this);
        wlClient.connect(new WLResponseListener() {
            @Override public void onSuccess(WLResponse wlResponse) {
                Log.i(TAG, "Connected to Worklight!");
            }

            @Override public void onFailure(WLFailResponse wlFailResponse) {
                Log.i(TAG, "Could not connect to Worklight!");
            }
        }, WLProcedureCaller.defaultOptions());
        wlClient.registerChallengeHandler(new ReadyAppsChallengeHandler(this, "SingleStepAuthRealm"));
    }

    @Override
    protected void onStart() {
        super.onStart();
        Apphance.onStart(this);
        if (fitClient != null) {
            fitClient.connect();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        Apphance.onStop(this);
        if (fitClient != null) {
            if (fitClient.isConnected()) {
                fitClient.disconnect();
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (fitClient != null) {
            if (requestCode == HealthDataRetriever.REQUEST_OAUTH) {
                HealthDataRetriever.authInProgress = false;
                if (resultCode == RESULT_OK) {
                    // Make sure the app is not already connected or attempting to connect
                    if (!fitClient.isConnecting() && !fitClient.isConnected()) {
                        fitClient.connect();
                    }
                }
            }
        }
    }

    /**
     * Acts as the onClickListener for the login button (set in the activity's XML layout file). It
     * can also be invoked from the soft keyboard on the device. It sends the input entered by the
     * user for patient ID and password to the DataManager for validation. It also passes a
     * callback to handle the result of the login attempt. A valid login causes the LandingActivity
     * to launch, while an invalid login will notify the user that either the patient ID or
     * password was invalid.
     *
     * @param view This is either the login button if the user clicks on the login button directly
     *             or the TextView of the password EditText if the user clicks "Done" on the soft
     *             keyboard.
     * @see com.ibm.mil.readyapps.physio.datamanager.DataManager
     * @see com.ibm.mil.readyapps.physio.activities.LandingActivity
     */
    public void submitLogin(View view) {
        mProgressDialog.show();

        // extract login input
        String patientId = mPatientText.getText().toString();
        String password = mPasswordText.getText().toString();
        String locale = getResources().getConfiguration().locale.toString();

        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("HealthcareAdapter", "submitAuthentication");
        Object[] params = new Object[] {patientId, password, locale};
        wlProcedureCaller.invoke(params, new WLResponseListener() {
            @Override public void onSuccess(final WLResponse wlResponse) {
                runOnUiThread(new Runnable() {
                    @Override public void run() {
                        ProgressFragment.clearData();
                        if (!injectGoogleFitData()) {
                            loadUserData();
                        }
                    }
                });
            }

            @Override public void onFailure(WLFailResponse wlFailResponse) {
                runOnUiThread(new Runnable() {
                    @Override public void run() {
                        mProgressDialog.dismiss();
                        showFailureDialog();
                    }
                });
            }
        });
    }

    private void showFailureDialog() {
        final PhysioDialog dialog = new PhysioDialog(this);

        Drawable icon = getResources().getDrawable(R.drawable.x_red);
        dialog.getIcon().setImageDrawable(icon);

        String failMessage = getResources().getString(R.string.login_failure);
        dialog.getPrimaryMessage().setText(failMessage);

        dialog.getSecondaryMessage().setVisibility(View.GONE);

        String buttonMessage = getResources().getString(R.string.login_failure_button);
        dialog.getButton().setText(buttonMessage);
        ColorDrawable colorDrawable = new ColorDrawable(getResources().getColor(R.color.ready_red));
        dialog.getButton().setBackground(colorDrawable);
        dialog.getButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.cancel();
            }
        });

        dialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                mPatientText.getEditableText().clear();
                mPasswordText.getEditableText().clear();
                findViewById(R.id.focus_decoy).requestFocus();
            }
        });

        dialog.show();
    }

    private boolean injectGoogleFitData() {
        if (mPatientText.getText().toString().equals("user2")) {
            String title = getString(R.string.injection_title);
            String message = getString(R.string.injection_message);
            ColorDrawable color = new ColorDrawable(getResources().getColor(R.color.ready_red));

            final PhysioAlertDialog alertDialog = new PhysioAlertDialog(this);
            alertDialog.setPrimaryText(title);
            alertDialog.setSecondaryText(message);
            alertDialog.setButtonDrawable(color);
            alertDialog.setPositiveClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alertDialog.dismiss();
                    new HealthDataInjector(LoginActivity.this, fitClient, new DataNotifier() {
                        @Override
                        public void dataIsAvailable() {
                            alertDialog.cancel();
                        }
                    }).inject();
                }
            });
            alertDialog.setPositiveText(getString(android.R.string.ok));
            alertDialog.setNegativeClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alertDialog.cancel();
                }
            });
            alertDialog.setNegativeText(getString(android.R.string.no));
            alertDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialog) {
                    loadUserData();
                }
            });
            alertDialog.show();

            return true;
        }

        return false;
    }

    private void loadUserData() {
        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("HealthcareAdapter", "getUserObject");
        wlProcedureCaller.invoke(null, new WLResponseListener() {
            @Override public void onSuccess(WLResponse wlResponse) {
                Patient currentPatient = new Patient(wlResponse.getResponseJSON());
                DataManager dataManager = DataManager.getInstance();
                dataManager.setCurrentPatient(currentPatient);
                loadFormData();
            }

            @Override public void onFailure(WLFailResponse wlFailResponse) {
                Log.i(TAG, "Could not load user data!");
                dataIsAvailable();
            }
        });
    }

    private void loadFormData() {
        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("HealthcareAdapter", "getQuestionnaireForUser");
        wlProcedureCaller.invoke(null, new WLResponseListener() {
            @Override public void onSuccess(WLResponse wlResponse) {
                Form[] forms = getFormsFromJson(wlResponse.getResponseJSON());
                DataManager.getCurrentPatient().setForms(Arrays.asList(forms));
                loadRoutineData();
            }

            @Override public void onFailure(WLFailResponse wlFailResponse) {
                Log.i(TAG, "Could not load form data!");
                loadRoutineData();
            }
        });
    }

    private Form[] getFormsFromJson(JSONObject jsonResp) {
        Form[] forms = new Form[0];

        try {
            // ((JSONArray) jsonResp).getJSONObject(1).getString("result");
            String stringResult = jsonResp.getString("result");
            JSONArray jsonArray = new JSONArray(stringResult);

            forms = new Form[jsonArray.length()];
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonResult = jsonArray.getJSONObject(i);
                Form form = new Form(jsonResult);

                forms[i] = form;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return forms;
    }

    @Override
    public void dataIsAvailable() {
        mProgressDialog.dismiss();
        startActivity(new Intent(this, LandingActivity.class));
        finish(); // prevent user from going back to LoginActivity
    }

    private void loadRoutineData() {
        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("HealthcareAdapter", "getRoutines");
        wlProcedureCaller.invoke(null, new WLResponseListener() {
            @Override public void onSuccess(WLResponse wlResponse) {
                Routine[] routines = getRoutinesFromJson(wlResponse.getResponseJSON());
                DataManager.getCurrentPatient().setRoutines(Arrays.asList(routines));
                loadExerciseData();
            }

            @Override public void onFailure(WLFailResponse wlFailResponse) {
                Log.i(TAG, "Could not load routine data!");
                loadExerciseData();
            }
        });
    }

    private Routine[] getRoutinesFromJson(JSONObject jsonResp) {
        Routine[] routines = new Routine[0];

        try {
            String stringResult = jsonResp.getString("result");
            JSONArray jsonArray = new JSONArray(stringResult);

            routines = new Routine[jsonArray.length()];
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonResult = jsonArray.getJSONObject(i);
                Routine routine = new Routine(jsonResult);

                routines[i] = routine;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return routines;
    }

    private void loadExerciseData() {
        final List<Routine> routines = DataManager.getCurrentPatient().getRoutines();

        // no routines to get data for, proceed to landing screen
        if (routines.isEmpty()) {
            dataIsAvailable();
        }

        for (final Routine routine : routines) {
            WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("HealthcareAdapter", "getExercisesForRoutine");
            Object[] params = new Object[] {routine.getId()};
            wlProcedureCaller.invoke(params, new WLResponseListener() {
                @Override public void onSuccess(final WLResponse wlResponse) {
                    runOnUiThread(new Runnable() {
                        @Override public void run() {
                            Exercise[] exercises = getExercisesFromJson(wlResponse.getResponseJSON());
                            DataManager.getCurrentPatient().addExercises(routine, Arrays.asList(exercises));

                            // check to see if all exercise data has been retrieved
                            int exerciseSets = DataManager.getCurrentPatient().getNumberOfExerciseSets();
                            if (exerciseSets == routines.size()) {
                                dataIsAvailable();
                            }
                        }
                    });

                }

                @Override public void onFailure(WLFailResponse wlFailResponse) {
                    Log.i(TAG, "Could not load exercise data!");

                    runOnUiThread(new Runnable() {
                        @Override public void run() {
                            dataIsAvailable();
                        }
                    });
                }
            });
        }
    }

    private Exercise[] getExercisesFromJson(JSONObject jsonResp) {
        Exercise[] exercises = new Exercise[0];

        try {
            String stringResult = jsonResp.getString("result");
            JSONArray jsonArray = new JSONArray(stringResult);

            exercises = new Exercise[jsonArray.length()];
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonResult = jsonArray.getJSONObject(i);
                Exercise exercise = new Exercise(jsonResult);

                exercises[i] = exercise;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return exercises;
    }

}
