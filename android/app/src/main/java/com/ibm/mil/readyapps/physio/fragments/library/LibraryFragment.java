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

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.ibm.mil.readyapps.physio.PhysioApplication;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.views.NoAssetsDialog;

public class LibraryFragment extends ListFragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Google Analytics
        Tracker tracker = PhysioApplication.tracker;
        tracker.setScreenName("Exercises list screen");
        tracker.send(new HitBuilders.ScreenViewBuilder().build());

        setListAdapter(new LibraryAdapter(getActivity(),
                getResources().getStringArray(R.array.library_items)));
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        getListView().setBackgroundColor(getResources().getColor(R.color.ready_gray));
        getListView().setDivider(getResources().getDrawable(R.drawable.divider_library));

        // if no data is available, notify user and block from proceeding
        if (DataManager.getCurrentPatient().getRoutines().isEmpty()) {
            new NoAssetsDialog(getActivity()).show();
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        // first item is 'Assigned' - go to routines
        if (position == 0) {
            getFragmentManager()
                    .beginTransaction()
                    .replace(R.id.fragment_container, new RoutineFragment())
                    .addToBackStack(null)
                    .commit();
        }
    }

    private class LibraryAdapter extends ArrayAdapter<String> {
        LibraryAdapter(Context context, String[] items) {
            super(context, R.layout.item_library, items);
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
                convertView = inflater.inflate(R.layout.item_library, parent, false);

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
            String listItem = getItem(position);
            holder.itemText.setText(listItem);

            // make 'Assigned' text blue
            if (listItem.equals(getString(R.string.assigned))) {
                holder.itemText.setTextColor(getResources().getColor(R.color.ready_blue));
            } else {
                holder.itemText.setTextColor(getResources().getColor(R.color.ready_dark_gray));
            }

            return convertView;
        }
    }

}
