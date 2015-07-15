
 /*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.activities;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.common.api.GoogleApiClient;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.datamanager.DataNotifier;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataInjector;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataRetriever;
import com.ibm.mil.readyapps.physio.datamanager.worklight.MyRequestListener;
import com.ibm.mil.readyapps.physio.datamanager.worklight.ReadyAppsChallengeHandler;
import com.ibm.mil.readyapps.physio.fragments.FormFragment;
import com.ibm.mil.readyapps.physio.fragments.LandingFragment;
import com.ibm.mil.readyapps.physio.fragments.PainLocationFragment;
import com.ibm.mil.readyapps.physio.fragments.ProgressFragment;
import com.ibm.mil.readyapps.physio.fragments.library.LibraryFragment;
import com.ibm.mil.readyapps.physio.interfaces.BackPressHandler;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.UnitLocale;
import com.ibm.mil.readyapps.physio.views.MenuAdapter;
import com.ibm.mil.readyapps.physio.views.PhysioAlertDialog;
import com.worklight.wlclient.api.WLClient;

import java.util.Stack;

public class LandingActivity extends ActionBarActivity implements AdapterView.OnItemClickListener {
    private DrawerLayout landingMenuDrawer;
    private ListView menuItems;
    // private String[] menuItemsTitles;
    private ActionBar actionBar;
    private ActionBarDrawerToggle menuListener;
    private ImageButton ouchButton;

    private GoogleApiClient mClient;
    private static Stack<Fragment> fragmentStack = new Stack<>();
    private static UnitLocale mCurrentUnitLocale = UnitLocale.getDefault();


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        // data may no longer exist due to timeout
        if (DataManager.getCurrentPatient() == null) {
            // return to login screen to re-validate user
            logout();
            return;
        }

        setContentView(R.layout.activity_landing);
        mClient = HealthDataRetriever.getClient(this);

        // refresh health data in case new locale uses different unit of measurement
        UnitLocale unitLocale = UnitLocale.getFrom(getResources().getConfiguration().locale);
        if (mCurrentUnitLocale != unitLocale) {
            mCurrentUnitLocale = unitLocale;
            ProgressFragment.clearData();
        }

        setupToolbarWithDrawer();

        if (fragmentStack.isEmpty() || fragmentStack.peek().getClass() != LandingFragment.class) {
            // load initial fragment into Activity
            getSupportFragmentManager().beginTransaction()
                    .add(R.id.fragment_container, new LandingFragment())
                    .commit();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();

        if (mClient != null) {
            mClient.connect();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();

        if (mClient != null) {
            if (mClient.isConnected()) {
                mClient.disconnect();
            }
        }

        WLClient client = WLClient.getInstance();
        client.logout(ReadyAppsChallengeHandler.CLIENT_REALM, new MyRequestListener());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (mClient != null) {
            if (requestCode == HealthDataRetriever.REQUEST_OAUTH) {
                HealthDataRetriever.authInProgress = false;
                if (resultCode == RESULT_OK) {
                    // Make sure the app is not already connected or attempting to connect
                    if (!mClient.isConnecting() && !mClient.isConnected()) {
                        mClient.connect();
                    }
                }
            }
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return menuListener.onOptionsItemSelected(item) || super.onOptionsItemSelected(item);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        selectItem(position);
    }

    private void selectItem(int position) {
        menuItems.setItemChecked(position, true);

        Fragment fragment;
        String backStackTag;
        switch (position) {
            case 1:
                fragment = new LandingFragment();
                backStackTag = LandingFragment.class.getSimpleName();
                break;
            case 2:
                // progress
                fragment = new ProgressFragment();
                backStackTag = ProgressFragment.class.getSimpleName();
                break;
            case 3:
                // pain management
                fragment = new PainLocationFragment();
                backStackTag = PainLocationFragment.class.getSimpleName();
                break;
            case 4:
                // exercise library
                fragment = new LibraryFragment();
                backStackTag = LibraryFragment.class.getSimpleName();
                break;
            case 5:
                // forms
                fragment = new FormFragment();
                backStackTag = FormFragment.class.getSimpleName();
                break;
            case 6:
                // log out
                if (DataManager.getCurrentPatient().getUserID().equals("user2")) {
                    deleteGoogleFitData();
                } else {
                    logout();
                }
                return;
            default:
                // invalid menu item
                return;
        }

        // only load the fragment if it's not currently visible
        if (!isCurrentFragment(fragment)) {
            getSupportFragmentManager().beginTransaction()
                    .replace(R.id.fragment_container, fragment)
                    .addToBackStack(backStackTag)
                    .commit();
        }

        closeDrawer();
    }

    private void setupToolbarWithDrawer() {
        landingMenuDrawer = (DrawerLayout) findViewById(R.id.landing_drawer_layout);
        menuItems = (ListView) findViewById(R.id.menu_list);
        menuItems.setOnItemClickListener(this);

        View header = getLayoutInflater().inflate(R.layout.menu_header, null);

        MenuAdapter menuAdapter = new MenuAdapter(this);
        menuAdapter.setUpHeader(header);
        menuItems.addHeaderView(header);
        menuItems.setAdapter(menuAdapter);
        Toolbar toolbar = new Toolbar(this);

        menuListener = new ActionBarDrawerToggle(this,landingMenuDrawer, toolbar,
                R.string.drawer_open, R.string.drawer_close) {
            @Override
            public void onDrawerOpened(View drawerView) {
                //switch menu icon to x icon
                getSupportActionBar().setHomeAsUpIndicator(R.drawable.x_button);
                super.onDrawerOpened(drawerView);
            }

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
                getSupportActionBar().setHomeAsUpIndicator(R.drawable.menu_button);
            }
        };

        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        LayoutInflater Inflator = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        View toolbarView = Inflator.inflate(R.layout.toolbar, null);
        TextView titleText = (TextView) toolbarView.findViewById(R.id.title_text);

        Typeface robotoBold = AndroidUtils.robotoBold(this);
        titleText.setTypeface(robotoBold);

        ouchButton = (ImageButton) toolbarView.findViewById(R.id.ouch_button);
        ouchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PainLocationFragment fragment = new PainLocationFragment();
                if (!isCurrentFragment(fragment)) {
                    getSupportFragmentManager().beginTransaction()
                            .replace(R.id.fragment_container, fragment)
                            .addToBackStack(PainLocationFragment.class.getSimpleName())
                            .commit();
                    landingMenuDrawer.closeDrawer(menuItems);
                }
            }
        });

        actionBar = getSupportActionBar();
        actionBar.setCustomView(toolbarView,
                new ActionBar.LayoutParams(ActionBar.LayoutParams.MATCH_PARENT,
                        ActionBar.LayoutParams.WRAP_CONTENT));
        actionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);

        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources()
                .getColor(android.R.color.black)));

        landingMenuDrawer.setDrawerListener(menuListener);
        getSupportActionBar().setHomeAsUpIndicator(R.drawable.menu_button);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    private void logout() {
        WLClient client = WLClient.createInstance(this);
        // WLClient client = WLClient.getInstance();
        client.logout(ReadyAppsChallengeHandler.CLIENT_REALM, new MyRequestListener());
        startActivity(new Intent(this, LoginActivity.class));
        finish();
    }

    private void deleteGoogleFitData() {
        String title = getString(R.string.delete_title);
        String message = getString(R.string.delete_message);
        ColorDrawable color = new ColorDrawable(getResources().getColor(R.color.ready_red));

        final PhysioAlertDialog alertDialog = new PhysioAlertDialog(this);
        alertDialog.setPrimaryText(title);
        alertDialog.setSecondaryText(message);
        alertDialog.setButtonDrawable(color);
        alertDialog.setPositiveText(getString(android.R.string.ok));
        alertDialog.setPositiveClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                alertDialog.dismiss();

                final Dialog progressDialog = AndroidUtils.circularProgressDialog(LandingActivity.this);
                progressDialog.show();

                new HealthDataInjector(LandingActivity.this, mClient, new DataNotifier() {
                    @Override
                    public void dataIsAvailable() {
                        progressDialog.dismiss();
                        mClient.disconnect();
                        alertDialog.cancel();
                    }
                }).delete();
            }
        });
        alertDialog.setNegativeText(getString(android.R.string.no));
        alertDialog.setNegativeClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                alertDialog.cancel();
            }
        });
        alertDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            @Override
            public void onCancel(DialogInterface dialog) {
                logout();
            }
        });
        alertDialog.show();
    }

    @Override
    public void onBackPressed() {
        closeDrawer();

        if (!fragmentStack.isEmpty()) {
            Fragment fragment = fragmentStack.peek();

            if (fragment instanceof BackPressHandler) {
                if (((BackPressHandler) fragment).backPressed()) {
                    return;
                }
            }

            fragmentStack.pop();
        }

        super.onBackPressed();
    }

    private boolean isCurrentFragment(Fragment fragment) {
        return fragment.getClass() == fragmentStack.peek().getClass();
    }

    @Override
    public void onAttachFragment(Fragment fragment) {
        super.onAttachFragment(fragment);
        fragmentStack.push(fragment);
    }

    /**
     * This will unwind the back stack to the state right before the specified fragment was
     * last introduced to the back stack. It does this my immediately popping off each fragment
     * on the back stack until the specified fragment is reached and popped off. It then creates
     * a fragment transaction to the LandingActivity if the now current fragment on the back stack
     * is not an instance of LandingActivity itself.
     *
     * @param clazz The class object of the initial fragment in the sequence that you want to
     *              unwind to
     */
    public void unwindFragmentBackStack(Class<? extends Fragment> clazz) {
        int backStackCount = getSupportFragmentManager().getBackStackEntryCount();
        getSupportFragmentManager().popBackStackImmediate(clazz.getSimpleName(),
                FragmentManager.POP_BACK_STACK_INCLUSIVE);
        backStackCount = backStackCount - getSupportFragmentManager().getBackStackEntryCount();

        for (int i = 0; i < backStackCount; i++) {
            fragmentStack.pop();
        }

        LandingFragment fragment = new LandingFragment();
        if (!isCurrentFragment(fragment)) {
            getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.fragment_container, new LandingFragment())
                    .addToBackStack(LandingFragment.class.getSimpleName())
                    .commit();
        }

        closeDrawer();
    }

    private void closeDrawer() {
        if (landingMenuDrawer.isDrawerOpen(GravityCompat.START)) {
            landingMenuDrawer.closeDrawer(menuItems);
            landingMenuDrawer.setVerticalScrollbarPosition(0);
        }
    }

    /**
     *
     * @return the height of the toolbar in LandingActivity
     */
    public int getToolbarHeight() {
        return actionBar.getHeight();
    }

    /**
     *
     * @param hide hide the pain (ouch) button in the LandingActivity toolbar
     */
    public void hidePainButton(boolean hide) {
        if (hide) {
            ouchButton.setVisibility(View.INVISIBLE);
        } else {
            ouchButton.setVisibility(View.VISIBLE);
        }
    }

}
