/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.fragments.library;

import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.android.youtube.player.YouTubeInitializationResult;
import com.google.android.youtube.player.YouTubePlayer;
import com.google.android.youtube.player.YouTubePlayerSupportFragment;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.activities.LandingActivity;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.models.Exercise;
import com.ibm.mil.readyapps.physio.models.Routine;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.Utils;
import com.ibm.mil.readyapps.physio.views.PhysioDialog;

import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class VideoFragment extends Fragment implements YouTubePlayer.OnInitializedListener {
    private static final String YOUTUBE_API_KEY = "AIzaSyCEhERD-H8vslrkVKady0t2odWUKExF5V8";

    private CountDownTimer timer;
    private VideoFragment thisFragment = this; // reference from within a listener

    public VideoFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View layout = inflater.inflate(R.layout.fragment_video, container, false);
        setupView(layout);
        return layout;
    }

    @Override
    public void onStop() {
        super.onStop();

        // prevent timer from firing after fragment has been removed
        if (timer != null) {
            timer.cancel();
        }
    }

    @Override
    public void onInitializationSuccess(YouTubePlayer.Provider provider, YouTubePlayer player,
                                        boolean wasRestored) {
        if (!wasRestored) {
            player.cueVideo(DataManager.getCurrentPatient().getSelectedExercise().getUrl());
        }
    }

    @Override
    public void onInitializationFailure(YouTubePlayer.Provider provider,
                                        YouTubeInitializationResult errorReason) {
        Log.i(LibraryFragment.class.getName(), errorReason.toString());
    }

    private void setupView(View view) {
        Exercise exercise = DataManager.getCurrentPatient().getSelectedExercise();

        TextView exerciseName = (TextView) view.findViewById(R.id.exercise_name);
        exerciseName.setTypeface(AndroidUtils.robotoRegular(exerciseName.getContext()));
        exerciseName.setText(exercise.getDescription());

        List<Routine> routines = DataManager.getCurrentPatient().getRoutines();
        Routine routine = DataManager.getCurrentPatient().getSelectedRoutine();
        int routineIndex = routines.indexOf(routine);
        TextView routineName = (TextView) view.findViewById(R.id.routine_name);
        routineName.setText((routineIndex + 1) + " of " + routines.size());

        TextView minutesValue = (TextView) view.findViewById(R.id.minutes_value);
        minutesValue.setTypeface(AndroidUtils.robotoBold(minutesValue.getContext()));
        minutesValue.setText(Utils.zeroPaddedNumber(exercise.getMinutes(), 2));
        TextView repetitionsValue = (TextView) view.findViewById(R.id.repetitions_value);
        repetitionsValue.setTypeface(AndroidUtils.robotoBold(repetitionsValue.getContext()));
        repetitionsValue.setText(Utils.zeroPaddedNumber(exercise.getRepetitions(), 2));
        TextView setsValue = (TextView) view.findViewById(R.id.sets_value);
        setsValue.setTypeface(AndroidUtils.robotoBold(setsValue.getContext()));
        setsValue.setText(Utils.zeroPaddedNumber(exercise.getSets(), 2));
        TextView toolsValue = (TextView) view.findViewById(R.id.tools);
        toolsValue.setText(exercise.getTools());

        TextView endRoutine = (TextView) view.findViewById(R.id.end_routine_button);
        endRoutine.setTypeface(AndroidUtils.robotoRegular(endRoutine.getContext()));
        endRoutine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.fragment_container, new EndRoutineFragment())
                        .addToBackStack(null)
                        .commit();
            }
        });

        TextView nextExercise = (TextView) view.findViewById(R.id.next_exercise_button);
        nextExercise.setTypeface(AndroidUtils.robotoRegular(nextExercise.getContext()));

        nextExercise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Exercise nextExercise = nextExercise();
                if (nextExercise != null) {
                    DataManager.getCurrentPatient().setSelectedExercise(nextExercise);
                    showNextExerciseDialog();
                } else {
                    showFinalExerciseDialog();
                }
            }
        });

        YouTubePlayerSupportFragment player = new YouTubePlayerSupportFragment();
        player.initialize(YOUTUBE_API_KEY, this);
        getChildFragmentManager()
                .beginTransaction()
                .add(R.id.youtube_container, player)
                .commit();
    }

    // helper to determine if more exercises are remaining in the current routine
    private Exercise nextExercise() {
        Routine currentRoutine = DataManager.getCurrentPatient().getSelectedRoutine();
        Exercise currentExercise = DataManager.getCurrentPatient().getSelectedExercise();

        List<Exercise> exerciseList = DataManager.getCurrentPatient().getExercises(currentRoutine);
        Iterator<Exercise> iterator = exerciseList.iterator();
        while (iterator.hasNext()) {
            if (currentExercise == iterator.next() && iterator.hasNext()) {
                return iterator.next();
            }
        }

        return null;
    }

    private void showNextExerciseDialog() {
        final PhysioDialog dialog = new PhysioDialog(getActivity());

        // customize dialog widgets
        Drawable dialogIcon = getResources().getDrawable(R.drawable.form_selected);
        dialog.getIcon().setImageDrawable(dialogIcon);
        String primaryMessage = getResources().getString(R.string.exercise_completed);
        dialog.getPrimaryMessage().setText(primaryMessage);
        String secondaryMessage = getResources().getString(R.string.next_timer_label);
        dialog.getSecondaryMessage().setText(secondaryMessage);
        String buttonText = getResources().getString(R.string.start_next);
        dialog.getButton().setText(buttonText);

        // set timer to advance to the next exercise automatically
        final String timerLabel = dialog.getSecondaryMessage().getText().toString();
        timer = new CountDownTimer(13000, 1000) {
            public void onTick(long millisUntilFinished) {
                // cancel if it reaches 1 sec (prevents delay)
                if (millisUntilFinished / 1000 == 1) {
                    dialog.getButton().performClick();
                }

                // subtract 2 secs so it finishes on 0:00
                long millis = millisUntilFinished - 2000;

                // convert millisUntilFinished into m:ss format (e.g. 0:10)
                String timerFormat = String.format("%01d:%02d",
                        TimeUnit.MILLISECONDS.toMinutes(millis),
                        TimeUnit.MILLISECONDS.toSeconds(millis) -
                                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS
                                        .toMinutes(millis)));
                dialog.getSecondaryMessage().setText(timerLabel + " " + timerFormat);
            }

            public void onFinish() {
                // stubbed out, takes too long for onFinish() to be called
                // look in onTick() for how it's handled...
            }
        };
        timer.start();

        // add click listener to dialog button
        dialog.getButton().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // go to next exercise video (refresh fragment)
                getFragmentManager()
                        .beginTransaction()
                        .detach(thisFragment)
                        .attach(thisFragment)
                        .commit();
                dialog.cancel();
            }
        });

        dialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                timer.cancel();
            }
        });

        dialog.show();
    }

    private void showFinalExerciseDialog() {
        final PhysioDialog dialog = new PhysioDialog(getActivity());

        dialog.getSecondaryMessage().setVisibility(View.GONE);
        dialog.getButton().setVisibility(View.GONE);

        // update primary message
        String updatedPrimaryMessage = getResources()
                .getString(R.string.todays_routine_completed);
        dialog.getPrimaryMessage().setText(updatedPrimaryMessage);

        dialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                showLandingScreen();
            }
        });
        dialog.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.cancel();
            }
        });

        dialog.show();
    }

    private void showLandingScreen() {
        ((LandingActivity) getActivity()).unwindFragmentBackStack(LibraryFragment.class);
    }

}
