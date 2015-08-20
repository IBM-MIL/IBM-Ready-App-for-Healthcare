/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("i18n", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC with test translations
    beforeEach(module('ReadyAppHC', function($translateProvider) {
        $translateProvider.translations('corgi', {
            _loading_:                      "GRR...",

            _minutes_dashboard_:            "BARK~",
            _exercises_dashboard_:          "BARK?",
            _sessions_dashboard_:           "BARK.",
            _get_started_dashboard_:        "BARK!",

            _day_tab_metrics_:              "BARK",
            _week_tab_metrics_:             "BARK BARK",
            _month_tab_metrics_:            "BARK BARK BARK",
            _year_tab_metrics_:             "BARK BARK BARK BARK",

            _hr_metrics_:                   "*tail wag*",
            _weight_metrics_:               "*rolls over*",
            _steps_metrics_:                "*flops ears*",
            _calories_metrics_:             "*sits*",
            _pain_metrics_:                 "*plays dead*",

            _hr_units_scrubber_:            "RUFF",
            _weight_units_scrubber_:        "RUFF RUFF",
            _steps_units_scrubber_:         "RUFF RUFF RUFF",
            _calories_units_scrubber_:      "RUFF RUFF RUFF RUFF",
            _pain_units_scrubber_:          "RUFF RUFF RUFF RUFF RUFF",

            _goal_detailed_metrics_:        "ARRR?",
            _view_all_detailed_metrics_:    "AROO?"
        });
    }));

    // Retrieve providers
    var $scope, $location, $route, $rootScope, $translate, $controller, $filter;

    beforeEach(inject(function(_$location_, _$route_, _$rootScope_, _$translate_, _$controller_, _$filter_) {
        $scope = _$rootScope_;
        $location = _$location_;
        $route = _$route_;
        $rootScope = _$rootScope_;
        $translate = _$translate_;
        $controller = _$controller_;
        $filter = _$filter_;
    }));
    
    var milCtrl;
    
    // Create milCtrl
    beforeEach(inject(function() {
        milCtrl = $controller("milCtrl", {
            $scope: $scope,
            $location: $location,
            $route: $route,
            $translate: $translate,
            $rootScope: $rootScope
        });
    }));
    
    /*
     *  Specs
     */
    
    it("should default to English", function() {
        expect($filter("translate")("_loading_")).toBe("Loading...");
        expect($filter("translate")("_minutes_dashboard_")).toBe("MINUTES");
        expect($filter("translate")("_exercises_dashboard_")).toBe("EXERCISES");
        expect($filter("translate")("_sessions_dashboard_")).toBe("SESSIONS");
        expect($filter("translate")("_get_started_dashboard_")).toBe("Get started!");
        
        expect($filter("translate")("_day_tab_metrics_")).toBe("Day");
        expect($filter("translate")("_week_tab_metrics_")).toBe("Week");
        expect($filter("translate")("_month_tab_metrics_")).toBe("Month");
        expect($filter("translate")("_year_tab_metrics_")).toBe("Year");
        
        expect($filter("translate")("_hr_metrics_")).toBe("Heart Rate");
        expect($filter("translate")("_weight_metrics_")).toBe("Weight");
        expect($filter("translate")("_steps_metrics_")).toBe("Steps");
        expect($filter("translate")("_calories_metrics_")).toBe("Calories");
        expect($filter("translate")("_pain_metrics_")).toBe("Pain");
        
        expect($filter("translate")("_hr_units_scrubber_")).toBe("avg bpm");
        expect($filter("translate")("_weight_units_scrubber_")).toBe("lbs");
        expect($filter("translate")("_steps_units_scrubber_")).toBe("steps");
        expect($filter("translate")("_calories_units_scrubber_")).toBe("kcal");
        expect($filter("translate")("_pain_units_scrubber_")).toBe(" / 10");
        
        expect($filter("translate")("_goal_detailed_metrics_")).toBe("Goal");
        expect($filter("translate")("_view_all_detailed_metrics_")).toBe("View All");
    });
    
    it("should translate keys", function() {
        // Set to corgi
        $scope.setLanguage("corgi");
        
        expect($filter("translate")("_loading_")).toBe("GRR...");
        expect($filter("translate")("_minutes_dashboard_")).toBe("BARK~");
        expect($filter("translate")("_exercises_dashboard_")).toBe("BARK?");
        expect($filter("translate")("_sessions_dashboard_")).toBe("BARK.");
        expect($filter("translate")("_get_started_dashboard_")).toBe("BARK!");
        
        expect($filter("translate")("_day_tab_metrics_")).toBe("BARK");
        expect($filter("translate")("_week_tab_metrics_")).toBe("BARK BARK");
        expect($filter("translate")("_month_tab_metrics_")).toBe("BARK BARK BARK");
        expect($filter("translate")("_year_tab_metrics_")).toBe("BARK BARK BARK BARK");
        
        expect($filter("translate")("_hr_metrics_")).toBe("*tail wag*");
        expect($filter("translate")("_weight_metrics_")).toBe("*rolls over*");
        expect($filter("translate")("_steps_metrics_")).toBe("*flops ears*");
        expect($filter("translate")("_calories_metrics_")).toBe("*sits*");
        expect($filter("translate")("_pain_metrics_")).toBe("*plays dead*");
        
        expect($filter("translate")("_hr_units_scrubber_")).toBe("RUFF");
        expect($filter("translate")("_weight_units_scrubber_")).toBe("RUFF RUFF");
        expect($filter("translate")("_steps_units_scrubber_")).toBe("RUFF RUFF RUFF");
        expect($filter("translate")("_calories_units_scrubber_")).toBe("RUFF RUFF RUFF RUFF");
        expect($filter("translate")("_pain_units_scrubber_")).toBe("RUFF RUFF RUFF RUFF RUFF");
        
        expect($filter("translate")("_goal_detailed_metrics_")).toBe("ARRR?");
        expect($filter("translate")("_view_all_detailed_metrics_")).toBe("AROO?");
    });
    
    // Done Testing

});