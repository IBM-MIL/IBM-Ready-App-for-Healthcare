/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

describe("milCtrl", function() {

    /*
     *  Setup
     */
    
    // Mock ReadyAppHC
    beforeEach(module('ReadyAppHC'));

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
    
    it("should change route", function() {
        $scope.switchRoute("/This/Is/A/Cool/Path", true);
        expect($location.path()).toBe("/This/Is/A/Cool/Path");
        
        $scope.switchRoute("/This/Path/Did/Not/Reload", false);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
    });
    
    it("should change language", function() {
        $scope.setLanguage("gibberish");
        expect($filter("translate")("blahblah")).toBe("blahblah");
        
        $scope.setLanguage("en");
        expect($filter("translate")("_loading_")).toBe("Loading...");
    });
    
    it("should resume/surrender route control", function() {
        $scope.switchRoute("/This/Is/A/Cool/Path", true);
        expect($location.path()).toBe("/This/Is/A/Cool/Path");
        
        $scope.switchRoute("/This/Path/Did/Not/Reload", false);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
        
        $scope.surrenderRouteControl();
        
        $scope.switchRoute("/This/Is/A/Cool/Path", true);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
        $scope.switchRoute("/This/Is/A/Cool/Path", false);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
        
        $scope.resumeRouteControl();
        
        $scope.switchRoute("/This/Is/A/Cool/Path", true);
        expect($location.path()).toBe("/This/Is/A/Cool/Path");
        $scope.switchRoute("/This/Path/Did/Not/Reload", false);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
    });
    
    // Done Testing

});