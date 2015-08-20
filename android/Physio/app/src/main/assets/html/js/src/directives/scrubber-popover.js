/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.scrubberPopover
 *  @memberOf ReadyAppHC
 *  @description An Angular directive that defines a scurbber for a graph in Physio.
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */

angular.module('ReadyAppHC').directive('scrubberPopover', function() {

    return {
        
        restrict: 'E',
        
        templateUrl: 'views/scrubber-popover.html',
    };
});