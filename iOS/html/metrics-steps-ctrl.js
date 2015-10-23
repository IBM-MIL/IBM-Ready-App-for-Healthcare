/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl
 *  @augments ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl
 *  @memberOf ReadyAppHC
 *  @description Controller the operates the steps metric view after tapping the "steps" graph
 *  in the {@linkcode metricsCtrl}.
 *  @see {@linkcode metrics-steps.html}
 *
 *  @property {string} unit             - The current unit that is selected in the tab bar (eg: day, week, month, year).
 *  @property {string} currTimeFrame    - The point in time that corresponds to {@linkcode unit}.
 *  @property {string} currPerformance  - The value for the number of steps taken in {@linkcode currTimeFrame}.
 *  @property {string} currGoal         - The goal for the number of steps taken in {@linkcode currTimeFrame}.
 *
 *  @author Jonathan Ballands
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */

angular.module('ReadyAppHC').controller('metricsStepsCtrl', function($scope, $controller, $filter, tab) {

    // Inheritance
    angular.extend(this, $controller('milSyncedGraphCtrl', {$scope: $scope, selectedTab: tab}));

    $scope.unit = $filter("translate")("_loading_");
    $scope.currTimeFrame = "";
    $scope.currPerformance = "...";
    $scope.currGoal = "...";

    $scope.measurementUnit = $filter("translate")("_steps_units_scrubber_");

    $scope.init = function() {
        $scope.baseRoute = "/WebView/metrics_steps";
    };

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl.viewAllClicked
     *  @description Redirects this back to the {@linkcode metricsCtrl} view, keeping the currently selected
     *  tab consistant.
     */
    $scope.viewAllClicked = function() {

        switch($scope.selectedTab) {
            case $scope.dayVal:
                $scope.switchRoute('/WebView/metrics_day');
                break;
            case $scope.weekVal:
                $scope.switchRoute('/WebView/metrics_week');
                break;
            case $scope.monthVal:
                $scope.switchRoute('/WebView/metrics_month');
                break;
            case $scope.yearVal:
                $scope.switchRoute('/WebView/metrics_year');
                break;
        }
    };

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl.setUnit
     *  @description Sets the unit that corresponds to the {@linkcode currTimeFrame} property.
     *  @param {string} unit The unit of time (eg: day, week, month, year).
     */
    $scope.setUnit = function(unit) {
        $scope.unit = unit;
    }

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl.setTimeFrame
     *  @description Sets the point in time that corresponds to the {@linkcode unit} property.
     *  @param {string} timeFrame The point in time that you are concerned with (eg: June 4, June 4 - June 11, June, or 2012).
     */
    $scope.setTimeFrame = function(timeFrame) {
        $scope.currTimeFrame = timeFrame;
    }

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl.setPerformance
     *  @description Sets the number of steps taken in {@linkcode currTimeFrame}.
     *  @param {string} performance The number of steps taken in the time frame (eg: 3,904).
     */
    $scope.setPerformance = function(performance) {
        $scope.currPerformance = performance;
    }

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsStepsCtrl.setGoal
     *  @description Sets the goal number of steps taken in {@linkcode currTimeFrame}.
     *  @param {string} performance The goal number of steps taken in the time frame.
     */
    $scope.setGoal = function(goal) {
        $scope.currGoal = goal;
    }

    // Go
    $scope.init();

});
