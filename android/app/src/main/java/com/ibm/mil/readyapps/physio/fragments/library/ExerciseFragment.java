/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.fragments.library;

import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.ibm.mil.readyapps.physio.PhysioApplication;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.models.Exercise;
import com.ibm.mil.readyapps.physio.models.Routine;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.Utils;

import java.util.List;

public class ExerciseFragment extends ListFragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Google Analytics
        Tracker tracker = PhysioApplication.tracker;
        tracker.setScreenName("Exercise screen");
        tracker.send(new HitBuilders.ScreenViewBuilder().build());

        View view = inflater.inflate(R.layout.fragment_exercise, container, false);

        // set custom typeface on header text
        Typeface robotoRegular = AndroidUtils.robotoRegular(getActivity());
        TextView routineName = (TextView) view.findViewById(R.id.routine_name);
        routineName.setTypeface(robotoRegular);
        TextView routineDirections = (TextView) view.findViewById(R.id.routine_directions);
        routineDirections.setTypeface(robotoRegular);

        return view;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Routine selectedRoutine = DataManager.getCurrentPatient().getSelectedRoutine();
        setListAdapter(new ExerciseAdapter(getActivity(),
                DataManager.getCurrentPatient().getExercises(selectedRoutine)));
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        if (getView() != null) {
            Routine routine = DataManager.getCurrentPatient().getSelectedRoutine();
            TextView routineName = (TextView) getView().findViewById(R.id.routine_name);
            routineName.setText(routine.getRoutineTitle());
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        Exercise selectedExercise = (Exercise) getListAdapter().getItem(position);
        DataManager.getCurrentPatient().setSelectedExercise(selectedExercise);

        getFragmentManager()
                .beginTransaction()
                .replace(R.id.fragment_container, new VideoFragment())
                .addToBackStack(null)
                .commit();
    }


    private class ExerciseAdapter extends ArrayAdapter<Exercise> {

        ExerciseAdapter(Context context, List<Exercise> items) {
            super(context, R.layout.item_exercise, items);
        }

        class ViewHolder {
            ImageView thumbnail;
            TextView description;
            TextView minsValue;
            TextView repsValue;
            TextView setsValue;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;

            if (convertView == null) {
                // inflate item layout
                LayoutInflater inflater = (LayoutInflater) getContext()
                        .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                convertView = inflater.inflate(R.layout.item_exercise, parent, false);

                // initialize view holder
                holder = new ViewHolder();
                holder.thumbnail = (ImageView) convertView.findViewById(R.id.thumbnail);
                holder.description = (TextView) convertView.findViewById(R.id.description);
                holder.description.setTypeface(AndroidUtils.robotoRegular(getContext()));
                holder.minsValue = (TextView) convertView.findViewById(R.id.mins_value);
                holder.repsValue = (TextView) convertView.findViewById(R.id.reps_value);
                holder.setsValue = (TextView) convertView.findViewById(R.id.sets_value);
                convertView.setTag(holder);
            } else {
                // recycle view
                holder = (ViewHolder) convertView.getTag();
            }

            // update item view
            Exercise listItem = getItem(position);
            holder.description.setText(listItem.getDescription());
            holder.minsValue.setText(Utils.zeroPaddedNumber(listItem.getMinutes(), 2));
            holder.repsValue.setText(Utils.zeroPaddedNumber(listItem.getRepetitions(), 2));
            holder.setsValue.setText(Utils.zeroPaddedNumber(listItem.getSets(), 2));

            return convertView;
        }
    }

}
