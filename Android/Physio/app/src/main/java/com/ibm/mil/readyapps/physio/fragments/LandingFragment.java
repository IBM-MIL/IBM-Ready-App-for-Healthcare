/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014, 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.physio.fragments;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.google.android.gms.common.api.GoogleApiClient;
import com.ibm.mil.readyapps.physio.R;
import com.ibm.mil.readyapps.physio.datamanager.DataManager;
import com.ibm.mil.readyapps.physio.datamanager.HealthDataRetriever;
import com.ibm.mil.readyapps.physio.fragments.library.LibraryFragment;
import com.ibm.mil.readyapps.physio.models.Exercise;
import com.ibm.mil.readyapps.physio.models.Routine;
import com.ibm.mil.readyapps.physio.utils.AndroidUtils;
import com.ibm.mil.readyapps.physio.utils.OnSwipeTouchListener;
import com.ibm.mil.readyapps.physio.utils.Utils;
import com.ibm.mil.readyapps.physio.views.metricstabs.HeartRateMetricsTab;
import com.ibm.mil.readyapps.physio.views.metricstabs.StepsMetricsTab;
import com.ibm.mil.readyapps.physio.views.metricstabs.WeightMetricsTab;
import com.ibm.mil.readyapps.webview.MILWebView;
import com.ibm.mil.readyapps.webview.OnPageChangeListener;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public class LandingFragment extends Fragment implements OnPageChangeListener {

    private static final int SLIDE_OFFSET = 320;
    private static final int ANIM_SPEED = 150;
    private static final int INIT_DELAY = 2500;

    private MILWebView mWebView;
    private GoogleApiClient mClient;

    private HeartRateMetricsTab heartRateTab;
    private WeightMetricsTab weightTab;
    private StepsMetricsTab stepsTab;
    private boolean metricsIsOpen = false;

    public LandingFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View layout = inflater.inflate(R.layout.fragment_landing, container, false);
        setupView(layout);
        return layout;
    }

    @Override
    public void onDetach() {
        super.onDetach();

        // effectively unregister this fragment from the WebView if it gets detached from Activity
        if (mWebView != null) {
            mWebView.setOnPageChangeListener(null);
        }
    }

    @Override
    public void onPageChange(List<String> urlChunks) {
        // listen for page changes
        if (urlChunks.contains("vid_library")) {
            getFragmentManager()
                    .beginTransaction()
                    .replace(R.id.fragment_container, new LibraryFragment())
                    .addToBackStack(LibraryFragment.class.getSimpleName())
                    .commit();
        } else {
            injectDashboardData();
        }
    }

    private void setupView(View view) {
        mClient = HealthDataRetriever.getClient(getActivity());
        if (!mClient.isConnected()) {
            mClient.connect();
        }

        mWebView = (MILWebView) view.findViewById(R.id.webview);
        mWebView.setOnPageChangeListener(this);
        mWebView.launchUrl("index.html#/WebView/dashboard");

        setupMetricsTabs(view);
    }

    private void setupMetricsTabs(View view) {
        LinearLayout metricsTabsArea = (LinearLayout) view.findViewById(R.id.metrics_tabs_area);

        heartRateTab = new HeartRateMetricsTab(getActivity(), null);
        heartRateTab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDetailedMetricsScreen(HealthDataRetriever.DataType.HEART_RATE);
            }
        });
        metricsTabsArea.addView(heartRateTab);

        if (DataManager.getCurrentPatient() == null) {
            return;
        }

        stepsTab = new StepsMetricsTab(getActivity(), null);
        stepsTab.setStepsGoal(DataManager.getCurrentPatient().getStepGoal());
        stepsTab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDetailedMetricsScreen(HealthDataRetriever.DataType.STEPS);
            }
        });
        metricsTabsArea.addView(stepsTab);

        weightTab = new WeightMetricsTab(getActivity(), null);
        weightTab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDetailedMetricsScreen(HealthDataRetriever.DataType.WEIGHT);
            }
        });
        metricsTabsArea.addView(weightTab);

        Calendar cal = Calendar.getInstance();
        Date now = new Date();
        cal.setTime(now);
        cal.add(Calendar.WEEK_OF_YEAR, -1);
        Date startDate = cal.getTime();

        HealthDataRetriever.Builder builder = new HealthDataRetriever.Builder()
                .startDate(startDate)
                .endDate(now)
                .timeUnit(TimeUnit.DAYS)
                .timeInterval(1);

        HealthDataRetriever stepsRetriever = builder
                .dataType(HealthDataRetriever.DataType.STEPS)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(final List<Integer> data) {
                        if (data != null) {
                            stepsTab.setSteps(Utils.sum(data));
                        }
                    }
                }).build();
        stepsRetriever.retrieve(mClient);

        HealthDataRetriever weightRetriever = builder
                .dataType(HealthDataRetriever.DataType.WEIGHT)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(final List<Integer> data) {
                        if (data != null) {
                            int lastWeight = data.get(data.size() - 1);
                            int firstWeight = data.get(0);
                            int netWeight = lastWeight - firstWeight;
                            weightTab.setWeight(lastWeight);
                            weightTab.setNetWeight(netWeight);
                        }
                    }
                }).build();
        weightRetriever.retrieve(mClient);

        HealthDataRetriever heartRateRetriever = builder
                .dataType(HealthDataRetriever.DataType.HEART_RATE)
                .handler(new HealthDataRetriever.Handler() {
                    @Override
                    public void handle(final List<Integer> data) {
                        if (data != null) {
                            heartRateTab.setBeatsPerMin(Utils.average(data));
                            heartRateTab.setMinMaxBpm(Utils.min(data), Utils.max(data));
                        }
                    }
                }).build();
        heartRateRetriever.retrieve(mClient);

        RelativeLayout metricsSwipeArea = (RelativeLayout) view.findViewById(R.id.metrics_swipe_area);

        metricsSwipeArea.setOnTouchListener(new OnSwipeTouchListener(getActivity()) {
            @Override
            public void onSwipeLeft() {
                if (!metricsIsOpen) {
                    animateMetricsIn(false);
                    metricsIsOpen = true;
                }
            }

            @Override
            public void onSwipeRight() {
                if (metricsIsOpen) {
                    animateMetricsOut(false);
                    metricsIsOpen = false;
                }
            }
        });

        animateMetricsOut(true);
    }

    private void openDetailedMetricsScreen(HealthDataRetriever.DataType type) {
        ProgressFragment fragment = new ProgressFragment();
        fragment.setMetricViewType(type);
        getFragmentManager()
                .beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .addToBackStack(ProgressFragment.class.getSimpleName())
                .commit();
    }

    private void animateMetricsIn(boolean isInitial) {
        int delay = 0;
        if (isInitial) {
            delay = INIT_DELAY;
        }

        ObjectAnimator heartRateSlideInAnimator =
                ObjectAnimator.ofFloat(heartRateTab, "translationX", 1f);
        ObjectAnimator weightSlideInAnimator =
                ObjectAnimator.ofFloat(weightTab, "translationX", 1f);
        ObjectAnimator stepsSlideInAnimator =
                ObjectAnimator.ofFloat(stepsTab, "translationX", 1f);

        heartRateSlideInAnimator.setDuration(ANIM_SPEED * 2);
        heartRateSlideInAnimator.setStartDelay(delay);

        weightSlideInAnimator.setDuration(ANIM_SPEED * 2);
        weightSlideInAnimator.setStartDelay(delay + (ANIM_SPEED * 2));

        stepsSlideInAnimator.setDuration(ANIM_SPEED * 2);
        stepsSlideInAnimator.setStartDelay(delay + ANIM_SPEED);

        AnimatorSet slideIn = new AnimatorSet();
        slideIn.play(heartRateSlideInAnimator)
                .with(stepsSlideInAnimator)
                .with(weightSlideInAnimator);
        slideIn.start();
    }

    private void animateMetricsOut(boolean isInitial) {
        int delay = 0;
        if (isInitial) {
            delay = INIT_DELAY;
        }

        ObjectAnimator weightSlideOutAnimator =
                ObjectAnimator.ofFloat(weightTab, "translationX", 1f + SLIDE_OFFSET);
        ObjectAnimator heartRateSlideOutAnimator =
                ObjectAnimator.ofFloat(heartRateTab, "translationX", 1f + SLIDE_OFFSET);
        ObjectAnimator stepsSlideOutAnimator =
                ObjectAnimator.ofFloat(stepsTab, "translationX", 1f + SLIDE_OFFSET);

        heartRateSlideOutAnimator.setDuration(ANIM_SPEED * 2);
        heartRateSlideOutAnimator.setStartDelay(ANIM_SPEED * 2);

        weightSlideOutAnimator.setDuration(ANIM_SPEED * 2);
        weightSlideOutAnimator.setStartDelay(delay);

        stepsSlideOutAnimator.setDuration(ANIM_SPEED * 2);
        stepsSlideOutAnimator.setStartDelay(ANIM_SPEED);

        AnimatorSet outAnimation = new AnimatorSet();
        outAnimation.play(weightSlideOutAnimator)
                .with(stepsSlideOutAnimator)
                .with(heartRateSlideOutAnimator);
        outAnimation.start();
    }

    private void injectDashboardData() {
        // populate landing page with data
        Locale locale = getResources().getConfiguration().locale;
        mWebView.setLanguage(locale);

        final StringBuilder builder = new StringBuilder();
        builder.append(MILWebView.getScopeObject());
        builder.append("scope.surrenderRouteControl();");
        builder.append("scope.$apply(function() {");

        // date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d", locale);
        String date = dateFormat.format(new Date());
        int day = Integer.parseInt(date.substring(date.indexOf(' ') + 1));
        date += AndroidUtils.numberSuffixLocalized(getActivity(), day);

        builder.append("scope.setDate('");
        builder.append(date);
        builder.append("');");

        // minutes and exercises
        Integer numberOfExercises = 0;
        Integer totalMinutes = 0;
        for (Routine routine : DataManager.getCurrentPatient().getRoutines()) {
            for (Exercise exercise : DataManager.getCurrentPatient().getExercises(routine)) {
                numberOfExercises++;
                totalMinutes += (int) Double.parseDouble(exercise.getMinutes());
            }
        }

        builder.append("scope.setMinutes('");
        builder.append(Utils.zeroPaddedNumber(totalMinutes.toString(), 2).substring(0, 2));
        builder.append("');");

        builder.append("scope.setExercises('");
        builder.append(Utils.zeroPaddedNumber(numberOfExercises.toString(), 2).substring(0, 2));
        builder.append("');");

        // sessions
        Integer numberOfSessions = DataManager.getCurrentPatient().getVisitsUsed();
        builder.append("scope.setSessions('");
        builder.append(Utils.zeroPaddedNumber(numberOfSessions.toString(), 2).substring(0, 2));
        builder.append("');");

        builder.append("});");
        builder.append("scope.resumeRouteControl();");

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                mWebView.injectJavaScript(builder.toString());
            }
        }, 250);
    }

}
