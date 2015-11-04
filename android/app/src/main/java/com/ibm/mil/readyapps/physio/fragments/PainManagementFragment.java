/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.fragments;

import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.ibm.mil.readyapps.physio.PhysioApplication;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.activities.LandingActivity;
import com.ibm.mil.readyapps.physio.models.PainReport;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.views.PhysioAlertDialog;
import com.ibm.mil.readyapps.physio.views.PhysioDialog;

import java.util.Date;

import antistatic.spinnerwheel.AbstractWheel;
import antistatic.spinnerwheel.OnWheelChangedListener;
import antistatic.spinnerwheel.WheelHorizontalView;
import antistatic.spinnerwheel.adapters.NumericWheelAdapter;
import io.realm.Realm;

public class PainManagementFragment extends Fragment {

    private WheelHorizontalView mPainPicker;
    private EditText mEnterPainDescription;

    private boolean isFormLayout; // determines which assets to load based on use

    public PainManagementFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Google Analytics
        Tracker tracker = PhysioApplication.tracker;
        tracker.setScreenName("Pain management screen");
        tracker.send(new HitBuilders.ScreenViewBuilder().build());

        /*
         * Two layouts exist only to defeat an Android API bug where customizing certain
         * background drawables at run-time would cause the layout to break when the EditText
         * widget became visible. The only difference between the first layout file and the second
         * one is the color chosen for certain background drawables.
         */
        View layout;
        if (isFormLayout) {
            layout = inflater.inflate(R.layout.fragment_form_pain_management, container, false);
        } else {
            layout = inflater.inflate(R.layout.fragment_pain_management, container, false);
        }
        setupView(layout);
        return layout;
    }

    @Override
    public void onStart() {
        super.onStart();
        ((LandingActivity) getActivity()).hidePainButton(true);
    }

    @Override
    public void onStop() {
        super.onStop();
        ((LandingActivity) getActivity()).hidePainButton(false);
    }

    private void setupView(View view) {
        // set custom fonts
        TextView painQuestion = (TextView) view.findViewById(R.id.pain_question);
        painQuestion.setTypeface(AndroidUtils.robotoRegular(view.getContext()));
        TextView painDescription = (TextView) view.findViewById(R.id.pain_description);
        painDescription.setTypeface(AndroidUtils.robotoBold(view.getContext()));
        mEnterPainDescription = (EditText) view.findViewById(R.id.enter_pain_description);
        mEnterPainDescription.setTypeface(AndroidUtils.robotoRegular(view.getContext()));
        Button submitButton = (Button) view.findViewById(R.id.pain_submit_button);
        submitButton.setTypeface(AndroidUtils.robotoRegular(view.getContext()));
        final TextView painCircleNumber = (TextView) view.findViewById(R.id.pain_circle_number);
        painCircleNumber.setTypeface(AndroidUtils.robotoBold(view.getContext()));

        // initialize pain picker
        int minScaleValue = 0;
        int maxScaleValue = 10;

        TextView minLabel = (TextView) view.findViewById(R.id.min_label);
        minLabel.setTypeface(AndroidUtils.robotoThin(view.getContext()));
        TextView maxLabel = (TextView) view.findViewById(R.id.max_label);
        maxLabel.setTypeface(AndroidUtils.robotoThin(view.getContext()));

        TextView minValue = (TextView) view.findViewById(R.id.min_value);
        minValue.setTypeface(AndroidUtils.robotoBold(view.getContext()));
        minValue.setText(Integer.toString(minScaleValue));

        TextView maxValue = (TextView) view.findViewById(R.id.max_value);
        maxValue.setTypeface(AndroidUtils.robotoBold(view.getContext()));
        maxValue.setText(Integer.toString(maxScaleValue));

        mPainPicker = (WheelHorizontalView) view.findViewById(R.id.pain_picker);
        NumericWheelAdapter painAdapter = new NumericWheelAdapter(
                view.getContext(), minScaleValue, maxScaleValue);
        painAdapter.setItemResource(R.layout.pain_picker_text);
        painAdapter.setItemTextResource(R.id.pain_text);
        painAdapter.setTextTypeface(AndroidUtils.robotoRegular(view.getContext()));
        mPainPicker.setViewAdapter(painAdapter);

        mPainPicker.setVisibleItems(maxScaleValue - minScaleValue);
        mPainPicker.setItemsDimmedAlpha(255);
        int defaultScore = (maxScaleValue - minScaleValue) / 2;
        mPainPicker.setCurrentItem(defaultScore);
        painCircleNumber.setText(Integer.toString(mPainPicker.getCurrentItem()));

        // update pain circle number with the current centered value
        mPainPicker.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(AbstractWheel wheel, int oldValue, int newValue) {
                painCircleNumber.setText(Integer.toString(newValue));
            }
        });

        submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final PhysioAlertDialog alertDialog = new PhysioAlertDialog(getActivity());
                String message;
                if (isFormLayout) {
                    message = getResources().getString(R.string.form_confirm);
                } else {
                    message = getResources().getString(R.string.pain_confirm);
                }
                alertDialog.setPrimaryText(message);
                alertDialog.hideSecondaryText(true);
                if (!isFormLayout) {
                    ColorDrawable color = new ColorDrawable(getResources().getColor(R.color.ready_red));
                    alertDialog.setButtonDrawable(color);
                }
                alertDialog.setPositiveClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Realm realm = Realm.getInstance(getActivity());
                        realm.beginTransaction();

                        PainReport report = realm.createObject(PainReport.class);
                        report.setDate(new Date());
                        report.setPainAmount(mPainPicker.getCurrentItem());
                        report.setDescription(mEnterPainDescription.getText().toString());

                        realm.commitTransaction();

                        // force refresh in ProgressFragment to show new pain report data
                        ProgressFragment.clearData();

                        final PhysioDialog dialog = new PhysioDialog(getActivity());

                        String message;
                        if (isFormLayout) {
                            message = getResources().getString(R.string.form_confirmed);
                        } else {
                            message = getResources().getString(R.string.pain_confirmed);
                            dialog.getIcon().setImageDrawable(getResources()
                                    .getDrawable(R.drawable.checkmark_red));
                        }

                        dialog.getPrimaryMessage().setText(message);
                        dialog.getSecondaryMessage().setVisibility(View.GONE);
                        dialog.getButton().setVisibility(View.GONE);
                        dialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                            @Override
                            public void onCancel(DialogInterface dialog) {
                                showLandingScreen();
                            }
                        });
                        dialog.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                showLandingScreen();
                                dialog.cancel();
                            }
                        });
                        dialog.show();
                        alertDialog.dismiss();
                    }
                });
                alertDialog.setNegativeClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                    }
                });
                alertDialog.show();
            }
        });
    }

    private void showLandingScreen() {
        Class<? extends Fragment> clazz;
        if (isFormLayout) {
            clazz = FormFragment.class;
        } else {
            clazz = PainLocationFragment.class;
        }
        ((LandingActivity) getActivity()).unwindFragmentBackStack(clazz);
    }

    /**
     * Call this after instantiating PainManagementFragment to use this fragment in Form layout
     * mode. In order for the UI changes to take effect, it must be called before a creating a
     * fragment transaction so onCreateView() can load the necessary assets.
     */
    public void enableFormLayout() {
        isFormLayout = true;
    }

}
