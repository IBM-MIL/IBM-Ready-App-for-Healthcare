/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("routing", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

    // Retrieve providers
    var $route;

    beforeEach(inject(function(_$route_) {
        $route = _$route_;
    }));
    
    /*
     *  Specs
     */
    
    it("should map routes to controllers", function() {
        expect($route.routes['/WebView/dashboard'].controller).toBe('dashboardCtrl');
        expect($route.routes['/WebView/dashboard'].templateUrl).toBe('views/dashboard.html');
        
        expect($route.routes['/WebView/metrics'].controller).toBe('metricsCtrl');
        expect($route.routes['/WebView/metrics'].templateUrl).toBe('views/metrics.html');
        expect($route.routes['/WebView/metrics_day'].controller).toBe('metricsCtrl');
        expect($route.routes['/WebView/metrics_day'].templateUrl).toBe('views/metrics.html');
        expect($route.routes['/WebView/metrics_week'].controller).toBe('metricsCtrl');
        expect($route.routes['/WebView/metrics_week'].templateUrl).toBe('views/metrics.html');
        expect($route.routes['/WebView/metrics_month'].controller).toBe('metricsCtrl');
        expect($route.routes['/WebView/metrics_month'].templateUrl).toBe('views/metrics.html');
        expect($route.routes['/WebView/metrics_year'].controller).toBe('metricsCtrl');
        expect($route.routes['/WebView/metrics_year'].templateUrl).toBe('views/metrics.html');
        
        expect($route.routes['/WebView/metrics_steps'].controller).toBe('metricsStepsCtrl');
        expect($route.routes['/WebView/metrics_steps'].templateUrl).toBe('views/metrics-steps.html');
        expect($route.routes['/WebView/metrics_steps_day'].controller).toBe('metricsStepsCtrl');
        expect($route.routes['/WebView/metrics_steps_day'].templateUrl).toBe('views/metrics-steps.html');
        expect($route.routes['/WebView/metrics_steps_week'].controller).toBe('metricsStepsCtrl');
        expect($route.routes['/WebView/metrics_steps_week'].templateUrl).toBe('views/metrics-steps.html');
        expect($route.routes['/WebView/metrics_steps_month'].controller).toBe('metricsStepsCtrl');
        expect($route.routes['/WebView/metrics_steps_month'].templateUrl).toBe('views/metrics-steps.html');
        expect($route.routes['/WebView/metrics_steps_year'].controller).toBe('metricsStepsCtrl');
        expect($route.routes['/WebView/metrics_steps_year'].templateUrl).toBe('views/metrics-steps.html');
        
        expect($route.routes['/WebView/metrics_hr'].controller).toBe('metricsHrCtrl');
        expect($route.routes['/WebView/metrics_hr'].templateUrl).toBe('views/metrics-hr.html');
        expect($route.routes['/WebView/metrics_hr_day'].controller).toBe('metricsHrCtrl');
        expect($route.routes['/WebView/metrics_hr_day'].templateUrl).toBe('views/metrics-hr.html');
        expect($route.routes['/WebView/metrics_hr_week'].controller).toBe('metricsHrCtrl');
        expect($route.routes['/WebView/metrics_hr_week'].templateUrl).toBe('views/metrics-hr.html');
        expect($route.routes['/WebView/metrics_hr_month'].controller).toBe('metricsHrCtrl');
        expect($route.routes['/WebView/metrics_hr_month'].templateUrl).toBe('views/metrics-hr.html');
        expect($route.routes['/WebView/metrics_hr_year'].controller).toBe('metricsHrCtrl');
        expect($route.routes['/WebView/metrics_hr_year'].templateUrl).toBe('views/metrics-hr.html');
        
        expect($route.routes['/WebView/metrics_weight'].controller).toBe('metricsWeightCtrl');
        expect($route.routes['/WebView/metrics_weight'].templateUrl).toBe('views/metrics-weight.html');
        expect($route.routes['/WebView/metrics_weight_day'].controller).toBe('metricsWeightCtrl');
        expect($route.routes['/WebView/metrics_weight_day'].templateUrl).toBe('views/metrics-weight.html');
        expect($route.routes['/WebView/metrics_weight_week'].controller).toBe('metricsWeightCtrl');
        expect($route.routes['/WebView/metrics_weight_week'].templateUrl).toBe('views/metrics-weight.html');
        expect($route.routes['/WebView/metrics_weight_month'].controller).toBe('metricsWeightCtrl');
        expect($route.routes['/WebView/metrics_weight_month'].templateUrl).toBe('views/metrics-weight.html');
        expect($route.routes['/WebView/metrics_weight_year'].controller).toBe('metricsWeightCtrl');
        expect($route.routes['/WebView/metrics_weight_year'].templateUrl).toBe('views/metrics-weight.html');
        
        expect($route.routes['/WebView/metrics_calories'].controller).toBe('metricsCaloriesCtrl');
        expect($route.routes['/WebView/metrics_calories'].templateUrl).toBe('views/metrics-calories.html');
        expect($route.routes['/WebView/metrics_calories_day'].controller).toBe('metricsCaloriesCtrl');
        expect($route.routes['/WebView/metrics_calories_day'].templateUrl).toBe('views/metrics-calories.html');
        expect($route.routes['/WebView/metrics_calories_week'].controller).toBe('metricsCaloriesCtrl');
        expect($route.routes['/WebView/metrics_calories_week'].templateUrl).toBe('views/metrics-calories.html');
        expect($route.routes['/WebView/metrics_calories_month'].controller).toBe('metricsCaloriesCtrl');
        expect($route.routes['/WebView/metrics_calories_month'].templateUrl).toBe('views/metrics-calories.html');
        expect($route.routes['/WebView/metrics_calories_year'].controller).toBe('metricsCaloriesCtrl');
        expect($route.routes['/WebView/metrics_calories_year'].templateUrl).toBe('views/metrics-calories.html');
        
        expect($route.routes['/WebView/metrics_pain'].controller).toBe('metricsPainCtrl');
        expect($route.routes['/WebView/metrics_pain'].templateUrl).toBe('views/metrics-pain.html');
        expect($route.routes['/WebView/metrics_pain_day'].controller).toBe('metricsPainCtrl');
        expect($route.routes['/WebView/metrics_pain_day'].templateUrl).toBe('views/metrics-pain.html');
        expect($route.routes['/WebView/metrics_pain_week'].controller).toBe('metricsPainCtrl');
        expect($route.routes['/WebView/metrics_pain_week'].templateUrl).toBe('views/metrics-pain.html');
        expect($route.routes['/WebView/metrics_pain_month'].controller).toBe('metricsPainCtrl');
        expect($route.routes['/WebView/metrics_pain_month'].templateUrl).toBe('views/metrics-pain.html');
        expect($route.routes['/WebView/metrics_pain_year'].controller).toBe('metricsPainCtrl');
        expect($route.routes['/WebView/metrics_pain_year'].templateUrl).toBe('views/metrics-pain.html');
    });
    
    // Done Testing

});