/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("metricsHrCtrl", function() {

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
    
    var metricsHrCtrl;
    
    // Create metricsCtrl
    beforeEach(inject(function(_$filter_) {
        metricsHrCtrl = $controller('metricsHrCtrl', {
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
        expect($scope.currTimeFrame).toBe("");
        expect($scope.currPerformance).toBe("...");
        expect($scope.baseRoute).toBe("/WebView/metrics_hr");
    });
    
    it("should set properties based on setters", function() {
        $scope.setUnit(42);
        expect($scope.unit).toBe(42);
        $scope.setUnit("Day");
        expect($scope.unit).toBe("Day");
        
        $scope.setTimeFrame(101014);
        expect($scope.currTimeFrame).toBe(101014);
        $scope.setTimeFrame("Oct 10 - Oct 17");
        expect($scope.currTimeFrame).toBe("Oct 10 - Oct 17");
        
        $scope.setPerformance(97);
        expect($scope.currPerformance).toBe(97);
        $scope.setPerformance("Ninety-seven");
        expect($scope.currPerformance).toBe("Ninety-seven");
    });
    
    it("should go back to the metricsCtrl while peristing the tab", function() {
        $scope.viewAllClicked();
        
        expect($location.path()).toBe("/WebView/metrics_day");
        
        $scope.tabClicked('week');
        $scope.viewAllClicked();
        expect($location.path()).toBe("/WebView/metrics_week");
        
        $scope.tabClicked('year');
        $scope.viewAllClicked();
        expect($location.path()).toBe("/WebView/metrics_year");
        
        $scope.tabClicked('month');
        $scope.viewAllClicked();
        expect($location.path()).toBe("/WebView/metrics_month");
    });
    
    // Done Testing

});