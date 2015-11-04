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
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.ibm.mil.readyapps.physio.PhysioApplication;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.activities.LandingActivity;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.views.PhysioAlertDialog;

import java.util.ArrayList;
import java.util.List;

public class EndRoutineFragment extends ListFragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Google Analytics
        Tracker tracker = PhysioApplication.tracker;
        tracker.setScreenName("End routine screen");
        tracker.send(new HitBuilders.ScreenViewBuilder().build());

        View view = inflater.inflate(R.layout.fragment_routine_end, container, false);

        // set custom typeface for header and footer text
        Typeface robotoRegular = AndroidUtils.robotoRegular(getActivity());
        TextView title = (TextView) view.findViewById(R.id.title);
        title.setTypeface(robotoRegular);
        Button submitButton = (Button) view.findViewById(R.id.submit_button);
        submitButton.setTypeface(robotoRegular);

        submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // show alert dialog asking if user wants to end their routine
                final PhysioAlertDialog alertDialog = new PhysioAlertDialog(getActivity());
                alertDialog.setPrimaryText(getString(R.string.end_routine_dialog_message));
                alertDialog.hideSecondaryText(true);
                alertDialog.setPositiveClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        // unwind entire exercise library fragment sequence from back stack
                        ((LandingActivity) getActivity())
                                .unwindFragmentBackStack(LibraryFragment.class);
                        alertDialog.cancel();
                    }
                });
                alertDialog.setNegativeClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.cancel();
                    }
                });
                alertDialog.show();
            }
        });

        return view;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        List<EndRoutineItem> items = new ArrayList<>();
        for (String item : getResources().getStringArray(R.array.end_routine_items)) {
            items.add(new EndRoutineItem(item));
        }

        setListAdapter(new EndRoutineAdapter(getActivity(), items));
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        EndRoutineAdapter.ViewHolder holder = (EndRoutineAdapter.ViewHolder) v.getTag();
        EndRoutineItem item = (EndRoutineItem) getListAdapter().getItem(position);
        if (item.isSelected) {
            item.isSelected = false;
            holder.itemText.setCompoundDrawablesWithIntrinsicBounds(R.drawable.form_unselected,
                    0, 0, 0);
        } else {
            item.isSelected = true;
            holder.itemText.setCompoundDrawablesWithIntrinsicBounds(R.drawable.form_selected,
                    0, 0, 0);
        }
    }

    private class EndRoutineItem {
        String itemText;
        boolean isSelected;

        EndRoutineItem(String itemText) {
            this.itemText = itemText;
        }
    }

    private class EndRoutineAdapter extends ArrayAdapter<EndRoutineItem> {

        EndRoutineAdapter(Context context, List<EndRoutineItem> items) {
            super(context, R.layout.item_selectable, items);
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
                convertView = inflater.inflate(R.layout.item_selectable, parent, false);

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
            holder.itemText.setText(getItem(position).itemText);
            if (getItem(position).isSelected) {
                holder.itemText.setCompoundDrawablesWithIntrinsicBounds(R.drawable.form_selected,
                        0, 0, 0);
            } else {
                holder.itemText.setCompoundDrawablesWithIntrinsicBounds(R.drawable.form_unselected,
                        0, 0, 0);
            }

            return convertView;
        }
    }

}
