/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl
 *  @memberOf ReadyAppHC
 *  @augments ReadyAppHC.milCtrl.milTabbedGraphCtrl
 *  @description Acts as the interface for all controllers that use graph directives. In
 *  Physio, this includes {@linkcode bar-graph.js}, {@linkcode line-graph.js},
 *  and {@linkcode time-graph.js}. {@linkcode milSyncedGraphCtrl} provides functionality that allows
 *  graphs to scroll and work synchronously with other graphs that exist in the same controller.
 *  Using a graph directive in a controller that isn't a decendent of this class will cause
 *  the graph to exhibit undefined behavior.
 *
 *  @property {object} transformData    - An object with only one key, {@linkcode xGraph}, that's used to determine the x-transform to apply to each graph. This property has a two-way binding with {@linkcode bar-graph} and {@linkcode line-graph} directives. When a graph requests a transform (that is, it had a pan gesture put upon it), it modifies the {@linkcode xGraph} value in this object. All other graphs are listening for changes on this property (hence the two-way binding) and will update themselves accordingly.
 *  @property {number} iter             - An iterator that allows graphs to consume data in the order that they appear. (See the {@linkcode nom} function to learn more.)
 *  @property {array} data              - An array of JSON data to be consumed by each graph. Graphs will consume data in this array from the top down. This means that the first piece of data in this array will be consumed by the first graph from the top, and the last piece of data in this array will be consumed by the first graph from the bottom.
 *
 *  @see {@linkcode milTabbedGraphCtrl}
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').controller('milSyncedGraphCtrl', function($scope, $controller, selectedTab) {

    // Inheritance
    angular.extend(this, $controller('milTabbedGraphCtrl', {$scope: $scope, selectedTab: selectedTab}));

    $scope.transformData = {
        xGraph : 0
    };
    $scope.iter = 0;
    $scope.data = undefined;
    $scope.dataLength = undefined;

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.applyData
     *  @description Sets the {@linkcode data} property in this controller and broadcasts an event that causes
     *  @param {array} data An array of JSON data that you would like to inject into each graph. The order of the JSON data matters (see the {@linkcode data} property to learn more). The JSON data must be stringified, but not the array itself.
     */
    $scope.applyData = function(data) {
        $scope.$apply(function() {
            $scope.data = data;
            data.length > 0 ? $scope.dataLength = JSON.parse(data[0]).length : $scope.dataLength = 0;
        });

        $scope.$broadcast('invalidate_graph', $scope.transformData.xGraph);
    };

    /**
     *  @function ReadyAppHC.milCtrl.milTabbedGraphCtrl.milSyncedGraphCtrl.nom
     *  @description Called by a graph when it wants to consume data. Implementations of {@linkcode bar-graph} and {@linkcode line-graph} call this function at the point where they want to consume JSON data (ie, when the graph is told to invalidate via a broadcast). This function uses the {@linkcode iter} property to determine what element in the {@linkcode data} array needs to be given to the graph.
     */
    $scope.nom = function() {
        var val = $scope.iter;

        if ($scope.iter < $scope.data.length - 1) {
            $scope.iter++;
        } else {
            $scope.iter = 0;
        }

        return $scope.data[val];
    };

});
