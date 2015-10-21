/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.milCtrl.dashboardCtrl
 *  @augments ReadyAppHC.milCtrl
 *  @memberOf ReadyAppHC
 *  @description Controller for the dashboard hybrid view that shows up right after
 *  logging into the app.
 *  @see {@linkcode dashboard.html}
 *
 *  @property {number} minutes      - The number for the minutes view.
 *  @property {number} exercises    - The number for the exercises view.
 *  @property {number} sessions     - The number for the sessions view.
 *  @property {string} date         - Today's date for the date view.
 *
 *  @author Jonathan Ballands
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').controller('dashboardCtrl', function($scope, $controller, $filter) {

    // Inheritance
    angular.extend(this, $controller('milCtrl', {$scope: $scope}));

    $scope.minutes = "...";
    $scope.exercises = "...";
    $scope.sessions = "...";
    $scope.date = $filter("translate")("_loading_");

    /**
     *  @function ReadyAppHC.milCtrl.dashboardCtrl.setMinutes
     *  @description Sets the exercises field in the dashboard hybrid view. The default value is -1.
     *  @param {number} mins The number of exercises that you would like to set the exercises field to.
     */
    $scope.setMinutes = function(mins) {
        $scope.minutes = mins;
    }

    /**
     *  @function ReadyAppHC.milCtrl.dashboardCtrl.setExercises
     *  @description Sets the exercises field in the dashboard hybrid view. The default value is -1.
     *  @param {number} exercises The number of exercises that you would like to set the exercises field to.
     */
    $scope.setExercises = function(exercises) {
        $scope.exercises = exercises;
    }

    /**
     *  @function ReadyAppHC.milCtrl.dashboardCtrl.setSessions
     *  @description Sets the sessions field in the dashboard hybrid view. The default value is -1.
     *  @param {number} sessions The number of sessions that you would like to set the sessions field to.
     */
    $scope.setSessions = function(sessions) {
        $scope.sessions = sessions;
    }

    /**
     *  @function ReadyAppHC.milCtrl.dashboardCtrl.setDate
     *  @description Sets the date field in the dashboard hybrid view.
     *  @param date The date  that you would like to set the date field to.
     */
    $scope.setDate = function(date) {
        $scope.date = date;
    }

    // Necessary to find screen height for older versions of
    // Android webview
    //document.getElementById('dshbrd_fill-height')
    //        .style.height = window.innerHeight + 'px';
    if (document.getElementById('a')) {
        document.getElementById('a')
            .style.height = window.innerHeight + 'px';
    }
});
