/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.metricsCtrl
 *  @augments ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl
 *  @memberOf ReadyAppHC
 *  @description Controller for graphs that provide insight into your recovery progress
 *  while using Physio.
 *  @see {@linkcode metrics.html}
 *  @author Jonathan Ballands
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').controller('metricsCtrl', function($scope, $controller, $filter, tab) {

    // Inheritance
    angular.extend(this, $controller('milSyncedGraphCtrl', {$scope: $scope, selectedTab: tab}));

    $scope.measurementUnitHr = $filter("translate")("_hr_units_scrubber_");
    $scope.measurementUnitWeight = $filter("translate")("_weight_units_scrubber_");
    $scope.measurementUnitSteps = $filter("translate")("_steps_units_scrubber_");
    $scope.measurementUnitCalories = $filter("translate")("_calories_units_scrubber_");
    $scope.measurementUnitPain = $filter("translate")("_pain_units_scrubber_");

    $scope.init = function() {
        $scope.baseRoute = "/WebView/metrics";
    };

    $scope.graphClicked = function(route) {

        switch($scope.selectedTab) {
            case $scope.dayVal:
                $scope.switchRoute(route + '_day');
                break;
            case $scope.weekVal:
                $scope.switchRoute(route + '_week');
                break;
            case $scope.monthVal:
                $scope.switchRoute(route + '_month');
                break;
            case $scope.yearVal:
                $scope.switchRoute(route + '_year');
                break;
        }
    };

    // Go
    $scope.init();

});
