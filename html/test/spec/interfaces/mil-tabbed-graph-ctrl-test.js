/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("milTabbedGraphCtrl", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

    // Retrieve providers
    var $scope, $location, $route, $rootScope, $translate, $controller;

    beforeEach(inject(function(_$location_, _$route_, _$rootScope_, _$translate_, _$controller_) {
        $scope = _$rootScope_;
        $location = _$location_;
        $route = _$route_;
        $rootScope = _$rootScope_;
        $translate = _$translate_;
        $controller = _$controller_;
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
    beforeEach(inject(function(_choreographerService_) {
        dashboardCtrl = $controller('milTabbedGraphCtrl', {
            $scope: $scope,
            $controller: $controller,
            choreographerService: _choreographerService_,
            selectedTab: 48
        });
        
        $scope.baseRoute = "/WebView/metrics";
        $scope.switchRoute("/WebView/metrics");
    }));
    
    /*
     *  Specs
     */
    
    it("should have correct initial property values", function() {
        expect($scope.dayVal).toBe(48);
        expect($scope.weekVal).toBe(14);
        expect($scope.monthVal).toBe(8);
        expect($scope.yearVal).toBe(24);
        expect($scope.displayType).toBe(0);
        expect($location.path()).toBe("/WebView/metrics");
    });
    
    it("should set values depending on the tab", function() {
        $scope.tabClicked('month');
        
        expect($scope.displayType).toBe(1);
        expect($scope.selectedTab).toBe(8);
        expect($location.path()).toBe("/WebView/metrics_month");
        
        $scope.tabClicked('day');
        
        expect($scope.displayType).toBe(0);
        expect($scope.selectedTab).toBe(48);
        expect($location.path()).toBe("/WebView/metrics_day");
        
        $scope.tabClicked('week');
        
        expect($scope.displayType).toBe(1);
        expect($scope.selectedTab).toBe(14);
        expect($location.path()).toBe("/WebView/metrics_week");
        
        $scope.tabClicked('year');
        
        expect($scope.displayType).toBe(1);
        expect($scope.selectedTab).toBe(24);
        expect($location.path()).toBe("/WebView/metrics_year");
    });
    
    // Done Testing

});