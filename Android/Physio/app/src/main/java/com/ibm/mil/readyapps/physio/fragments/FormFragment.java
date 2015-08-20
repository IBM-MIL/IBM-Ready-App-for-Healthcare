/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.fragments;

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

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.models.Form;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.views.NoAssetsDialog;

import java.util.ArrayList;
import java.util.List;

public class FormFragment extends ListFragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_form, container, false);

        // set custom typeface on header and footer text
        Typeface robotoRegular = AndroidUtils.robotoRegular(getActivity());
        TextView title = (TextView) view.findViewById(R.id.title);
        title.setTypeface(robotoRegular);
        TextView directions = (TextView) view.findViewById(R.id.directions);
        directions.setTypeface(robotoRegular);
        Button nextButton = (Button) view.findViewById(R.id.next_button);
        nextButton.setTypeface(robotoRegular);

        nextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PainLocationFragment fragment = new PainLocationFragment();
                fragment.setBlue(true);

                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.fragment_container, fragment)
                        .addToBackStack(null)
                        .commit();
            }
        });

        return view;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (DataManager.getCurrentPatient() == null) {
            return;
        }

        if (DataManager.getCurrentPatient().getForms().isEmpty()) {
            new NoAssetsDialog(getActivity()).show();
        }

        List<FormItem> items = new ArrayList<>();
        for (Form form : DataManager.getCurrentPatient().getForms()) {
            items.add(new FormItem(form.getTextDescription()));
        }

        setListAdapter(new FormAdapter(getActivity(), items));
    }

    @Override
    public void onListItemClick(ListView l, View v, final int position, long id) {
        super.onListItemClick(l, v, position, id);

        FormAdapter.ViewHolder holder = (FormAdapter.ViewHolder) v.getTag();
        FormItem item = (FormItem) getListAdapter().getItem(position);
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

    private class FormItem {
        String itemText;
        boolean isSelected;

        public FormItem(String itemText) {
            this.itemText = itemText;
        }
    }

    private class FormAdapter extends ArrayAdapter<FormItem> {

        FormAdapter(Context context, List<FormItem> items) {
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
