/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.fragments.library;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.models.Routine;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;

import java.util.List;

public class RoutineFragment extends ListFragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setListAdapter(new RoutineAdapter(getActivity(),
                DataManager.getCurrentPatient().getRoutines()));
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        getListView().setBackgroundColor(getResources().getColor(R.color.ready_blue));
        getListView().setDivider(getResources().getDrawable(R.drawable.divider_routine));
    }

    @Override
    public void onListItemClick(ListView l, View v, final int position, long id) {
        super.onListItemClick(l, v, position, id);

        DataManager.getCurrentPatient()
                .setSelectedRoutine((Routine) getListAdapter().getItem(position));

        getFragmentManager()
                .beginTransaction()
                .replace(R.id.fragment_container, new ExerciseFragment())
                .addToBackStack(null)
                .commit();
    }

    private class RoutineAdapter extends ArrayAdapter<Routine> {

        RoutineAdapter(Context context, List<Routine> items) {
            super(context, R.layout.item_routine, items);
        }

        class ViewHolder {
            TextView itemText;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;

            if (convertView == null) {
                // inflate item layout
                LayoutInflater inflater = (LayoutInflater) getContext()
                        .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                convertView = inflater.inflate(R.layout.item_routine, parent, false);

                // initialize view holder
                holder = new ViewHolder();
                holder.itemText = (TextView) convertView.findViewById(R.id.item_text);
                holder.itemText.setTypeface(AndroidUtils.robotoRegular(getContext()));
                convertView.setTag(holder);
            } else {
                // recycle view
                holder = (ViewHolder) convertView.getTag();
            }

            // update item view
            Routine listItem = getItem(position);
            holder.itemText.setText(listItem.getRoutineTitle());

            return convertView;
        }
    }

}
