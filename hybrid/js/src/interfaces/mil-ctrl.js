/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.milCtrl
 *  @memberOf ReadyAppHC
 *  @description The basis for every controller in Physio.
 *  Think of this as {@linkcode Object} in Java or {@linkcode NSObject} in Cocoa.
 *  {@linkcode milCtrl} provides important functions that all controllers in Physio must possess, including
 *  the ability to route to other controllers in Physio. It is highly recommended that you extend this
 *  controller when implementing a new controller class.
 *  Creating a controller that is not a decendent of
 *  this class is not necessarily an error, but makes your life harder in the long run.
 *  @property {boolean} clientIsReady    - True if the client is ready with HealthKit/Google Fit data, false if not.
 *  @author Jonathan Ballands
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').controller('milCtrl', function($scope, $location, $route, $rootScope, $translate) {
    
    // Used to determine if the route should change
    $scope.clientIsReady = true;
    
    /**
     *  @function ReadyAppHC.milCtrl.switchRoute
     *  @description An extension of the {@linkcode $location}.{@linkcode path} service that allows you to specify
     *  if you want the page to refresh or not when the path changes.
     *  @param {string} path The path you want to navigate to.
     *  @param {boolean} reload True if you want the page to reload, false if not.
     */
    $scope.switchRoute = function(path, reload) {
        if (!$scope.clientIsReady) {
            console.warn("milCtrl: A route change was requested, but the hybrid has surrendered routing control at this time. (Did you call resumeRouteControl() first?)");
            return;
        }
        
        if (reload === false) {
            var lastRoute = $route.current;
            var un = $rootScope.$on('$locationChangeSuccess', function () {
                $route.current = lastRoute;
                un();
            });
        }
        return $location.path.apply($location, [path]);
    };
    
    /**
     *  @function ReadyAppHC.milCtrl.setLanguage
     *  @description Sets the language to be used, using {@linkcode i18n.js} as the language reference.
     *  The default language is English.
     *  @param lang The locale code for the language to be used. (Ex: en, fr, es, de, etc.)
     */
    $scope.setLanguage = function(lang) {
        $translate.use(lang);
        // Reload
        $route.reload();
    };
    
    /**
     *  @function ReadyAppHC.milCtrl.resumeRouteControl
     *  @description Acts as a callback that the native portion of the app uses to let
     *  the hybrid know that it can resume routing control.
     */
    $scope.resumeRouteControl = function() {
        $scope.clientIsReady = true;
    };
    
    /**
     *  @function ReadyAppHC.milCtrl.surrenderControl
     *  @description Lets the hybrid know that is cannot process route changes at this time.
     */
    $scope.surrenderRouteControl = function() {
        $scope.clientIsReady = false;
    };
    
});
