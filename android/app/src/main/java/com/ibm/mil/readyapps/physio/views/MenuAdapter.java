/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */
package com.ibm.mil.readyapps.physio.views;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.Utils;

import java.util.Date;
import java.util.Locale;

public class MenuAdapter extends BaseAdapter {
    private String[] menuItemsTitles;
    private Context context;

    public MenuAdapter(Context context) {
        menuItemsTitles = context.getResources().getStringArray(R.array.menu_items);
        this.context = context;
    }

    @Override
    public int getCount() {
        return menuItemsTitles.length;
    }

    @Override
    public Object getItem(int position) {
        return menuItemsTitles[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row;
        if (convertView == null) {
            LayoutInflater menuInflator = (LayoutInflater)
                    context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            row = menuInflator.inflate(R.layout.menu_row, parent, false);
        } else {
            row = convertView;
        }

        TextView rowText = (TextView) row.findViewById(R.id.row_text);
        rowText.setText(menuItemsTitles[position]);
        rowText.setTypeface(AndroidUtils.robotoRegular(context));

        return row;
    }

    public void setUpHeader(View header) {
        Typeface robotoBold = AndroidUtils.robotoBold(this.context);
        TextView patientID = (TextView) header.findViewById(R.id.menu_patient_id);
        TextView patientIDSubtitle = (TextView) header.findViewById(R.id.menu_subtitle_patient_id);
        TextView nextVisit = (TextView) header.findViewById(R.id.menu_next_visit);
        TextView nextVisitSubtitle = (TextView) header.findViewById(R.id.menu_subtitle_next_visit);
        TextView week = (TextView) header.findViewById(R.id.menu_week);
        TextView weekSubtitle = (TextView) header.findViewById(R.id.menu_subtitle_week);

        patientID.setText(DataManager.getCurrentPatient().getUserID());
        patientID.setTypeface(robotoBold);
        patientIDSubtitle.setText(context.getResources().getString(R.string.patient_id_subtitle));

        // set localized date for next visit
        Locale locale = context.getResources().getConfiguration().locale;
        Date nextDate = DataManager.getCurrentPatient().getDateOfNextVisit();
        nextVisit.setText(Utils.localizedDateWithoutYear(nextDate, locale));
        nextVisit.setTypeface(robotoBold);

        nextVisitSubtitle.setText(context.getResources().getString(R.string.next_visit_subtitle));
        week.setText("Visit " + DataManager.getCurrentPatient().getVisitsUsed() + "/" + DataManager.getCurrentPatient().getVisitsTotal());
        week.setTypeface(robotoBold);
        weekSubtitle.setText(context.getResources().getString(R.string.week_subtitle));
    }

}