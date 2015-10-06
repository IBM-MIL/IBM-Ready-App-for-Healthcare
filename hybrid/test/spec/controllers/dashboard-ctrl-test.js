/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("dashboardCtrl", function() {

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
    
    var dashboardCtrl;
    
    // Create dashboardCtrl
    beforeEach(inject(function(_$filter_) {
        dashboardCtrl = $controller('dashboardCtrl', {
            $scope: $scope,
            $controller: $controller,
            $filter: _$filter_
        });
    }));
    
    /*
     *  Specs
     */
    
    it("should have correct initial property values", function() {
        expect($scope.minutes).toBe("...");
        expect($scope.exercises).toBe("...");
        expect($scope.sessions).toBe("...");
        expect($scope.date).toBe("Loading...");
    });
    
    it("should set properties based on setters", function() {
        $scope.setMinutes("Five");
        expect($scope.minutes).toBe("Five");
        $scope.setMinutes(5);
        expect($scope.minutes).toBe(5);
        
        $scope.setExercises("Five");
        expect($scope.exercises).toBe("Five");
        $scope.setExercises(5);
        expect($scope.exercises).toBe(5);
        
        $scope.setSessions("Five");
        expect($scope.sessions).toBe("Five");
        $scope.setSessions(5);
        expect($scope.sessions).toBe(5);
        
        $scope.setDate("October Tenth, Two-Thousand and Fourteen");
        expect($scope.date).toBe("October Tenth, Two-Thousand and Fourteen");
        $scope.setDate(101014);
        expect($scope.date).toBe(101014);
    });
    
    // Done Testing

});