/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("metricsCtrl", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

    // Retrieve providers
    var $scope, $location, $route, $rootScope, $translate, $controller, choreographerService, graphMapper;

    beforeEach(inject(function(_$location_, _$route_, _$rootScope_, _$translate_, _$controller_, _choreographerService_, _graphMapFactory_) {
        $scope = _$rootScope_;
        $location = _$location_;
        $route = _$route_;
        $rootScope = _$rootScope_;
        $translate = _$translate_;
        $controller = _$controller_;
        choreographerService = _choreographerService_;
        graphMapper = _graphMapFactory_;
    }));
    
    var milCtrl;
    
    // Create milCtrl
    beforeEach(inject(function() {
        milCtrl = $controller('milCtrl', {
            $scope: $scope,
            $location: $location,
            $route: $route,
            $translate: $translate,
            $rootScope: $rootScope
        });
    }));
    
    var milTabbedGraphCtrl;
    
    // Create milTabbedGraphCtrl
    beforeEach(inject(function() {
        milTabbedGraphCtrlCtrl = $controller('milTabbedGraphCtrl', {
            $scope: $scope,
            $controller: $controller,
            choreographerService: choreographerService,
            selectedTab: 48
        });
    }));
    
    var milSyncedGraphCtrl;
    
    // Create milSyncedGraphCtrl
    beforeEach(inject(function() {
        milSyncedGraphCtrl = $controller('milSyncedGraphCtrl', {
            $scope: $scope,
            $controller: $controller,
            selectedTab: 48
        });
    }));
    
    var metricsCtrl;
    
    // Create metricsCtrl
    beforeEach(inject(function(_$filter_) {
        metricsCtrl = $controller('metricsCtrl', {
            $scope: $scope,
            $controller: $controller,
            $filter: _$filter_,
            tab: 48
        });
    }));
    
    /*
     *  Specs
     */
    
    it("should have correct initial property values", function() {
        expect($scope.baseRoute).toBe("/WebView/metrics");
    });
    
    it("should route to a new graph while peristing the tab", function() {
        $scope.graphClicked("/WebView/metrics_steps");
        
        expect($location.path()).toBe("/WebView/metrics_steps_day");
        
        $scope.tabClicked('month');
        $scope.graphClicked("/WebView/metrics_hr");
        
        expect($location.path()).toBe("/WebView/metrics_hr_month");
        
        $scope.tabClicked('week');
        $scope.graphClicked("/WebView/metrics_weight");
        
        expect($location.path()).toBe("/WebView/metrics_weight_week");
        
        $scope.tabClicked('year');
        $scope.graphClicked("/WebView/metrics_calories");
        
        expect($location.path()).toBe("/WebView/metrics_calories_year");
        
        $scope.tabClicked('day');
        $scope.graphClicked("/WebView/metrics_pain");
        
        expect($location.path()).toBe("/WebView/metrics_pain_day");
    });
    
    // Done Testing

});