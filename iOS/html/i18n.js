/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

readyApp.config(function($translateProvider) {
    
    /*
     *  English
     */
    $translateProvider.translations('en', {
        _loading_:                      "Loading...",
        
        _minutes_dashboard_:            "MINUTES",
        _exercises_dashboard_:          "EXERCISES",
        _sessions_dashboard_:           "SESSIONS",
        _get_started_dashboard_:        "Get started!",
        
        _day_tab_metrics_:              "Day",
        _week_tab_metrics_:             "Week",
        _month_tab_metrics_:            "Month",
        _year_tab_metrics_:             "Year",
        
        _hr_metrics_:                   "Heart Rate",
        _weight_metrics_:               "Weight",
        _steps_metrics_:                "Steps",
        _calories_metrics_:             "Calories",
        _pain_metrics_:                 "Pain",
        
        _hr_units_scrubber_:            "avg bpm",
        _weight_units_scrubber_:        "lbs",
        _steps_units_scrubber_:         "steps",
        _calories_units_scrubber_:      "kcal",
        _pain_units_scrubber_:          " / 10",
        
        _goal_detailed_metrics_:        "Goal",
        _view_all_detailed_metrics_:    "View All"
    });
    
    /*
     *  English US
     */
    $translateProvider.translations('en_US', {
        _loading_:                      "Loading...",
        
        _minutes_dashboard_:            "MINUTES",
        _exercises_dashboard_:          "EXERCISES",
        _sessions_dashboard_:           "SESSIONS",
        _get_started_dashboard_:        "Get started!",
        
        _day_tab_metrics_:              "Day",
        _week_tab_metrics_:             "Week",
        _month_tab_metrics_:            "Month",
        _year_tab_metrics_:             "Year",
        
        _hr_metrics_:                   "Heart Rate",
        _weight_metrics_:               "Weight",
        _steps_metrics_:                "Steps",
        _calories_metrics_:             "Calories",
        _pain_metrics_:                 "Pain",
        
        _hr_units_scrubber_:            "avg bpm",
        _weight_units_scrubber_:        "lbs",
        _steps_units_scrubber_:         "steps",
        _calories_units_scrubber_:      "kcal",
        _pain_units_scrubber_:          " / 10",
        
        _goal_detailed_metrics_:        "Goal",
        _view_all_detailed_metrics_:    "View All"
    });
        
    $translateProvider.preferredLanguage('en');
    
    $translateProvider.fallbackLanguage('en');
});