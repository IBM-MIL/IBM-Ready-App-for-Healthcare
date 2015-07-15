/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.graphMapProvider
 *  @memberOf ReadyAppHC
 *  @description A provider that allows graphs to map an x-transform to a data point; that is, a hash table that takes an x-transform and describes the data point related to that x-transform. This provider is created by an factory known as the {@linkcode graphMapFactory}.
 *  @example
 *  var graphMap = new graphMapFactory();
 *  graphMap.setParams(-50, 50, [1, 5, 9, 4]);
 *  graphMap.map(49);  // Returns 4
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').factory('graphMapFactory', function() {

    var graphMap = function() {
        var _min = undefined;
        var _max = undefined;
        var _data = undefined;
        var _delta = undefined;
        var _tab = undefined;

        var needsParams = true;

        /**
         *  @function ReadyAppHC.graphMapProvider.setParams
         *  @description Sets up the provider so that the hash function has values to operate with.
         *  @param {number} min The leftmost bound for a horizontal transform on a graph (usually a positive number); that is, the transform value for the x-axis where the graph's left most edge won't scroll right anymore.
         *  @param {number} max The rightmost bound for a horizontal transform on a graph (usually a negative number); that is, the transform value for the x-axis where the graph's right most edge won't scroll left anymore.
         *  @param {array} outs An array of output data that the mapping algorithm will point to given an input; that is, an array of only y-values.
         *  @param {tab} Allows this mapper to correctly map the time relative to now that corresponds to a particular transform value.
         */
        this.setParams = function(min, max, outs, tab) {
            _min = min;
            _max = max;
            _data = outs;
            _delta = (Math.abs(_min) + Math.abs(_max)) / _data.length;
            if (tab != 48 && tab != 14 && tab != 8 && tab != 12) {
                console.warn("dataMappingService: Tab parameter not a recognized value! (Should be 48, 14, 8, or 24)");
            }
            _tab = tab;
            needsParams = false;
            
            console.info("dataMappingService: Paramaters set. Ready to map!");
        };
        
        /**
         *  @function ReadyAppHC.graphMapProvider.mapTime
         *  @description Maps the time at a given transform on the x-axis.
         *  @param {number} tx The transform currently being applied to the graph.
         *  @returns A time relative to now that corresponds to the transform.
         */
        this.mapTime = function(tx) {
            if (needsParams) {
                console.error("dataMappingService.mapTime: Needs mapping paramaters!");
                return undefined;
            }
            if (tx > _max || tx < _min) {
                console.error("dataMappingService.mapTime: Transform out of range!");
                return undefined;
            }
            
            var index = (_data.length - Math.floor((tx + Math.abs(Math.min(_min, _max))) / _delta)) * -1;
            if (index > -1) {
                index = -1;
            }
            
            // invIndex has -1 taken into account already, so no need to subtract 1
            var invIndex = ((index % _data.length) + _data.length) % _data.length;
            
            switch(_tab) {
                case 48:
                    var d = moment.duration(1, 'hour');
                    var m = moment().subtract(invIndex * d);
                    return m.format("MMM Do, h:mm a");
                case 14:
                    var d = moment.duration(1, 'day');
                    var m = moment().subtract(invIndex * d);
                    return m.format("MMM Do, dddd");
                case 8:
                    var d = moment.duration(1, 'week');
                    // -invIndex days because the timeGraph displays the dates so that they
                    // don't overlap. -3 days so this can show the date near the middle of the interval
                    var m = moment().subtract(invIndex * d).subtract(invIndex, 'days').subtract(3, 'days');
                    return m.format("MMMM YYYY");
                    break;
                case 24:
                    var d = moment.duration(1, 'month');
                    var m = moment().subtract(invIndex * d);
                    return m.format("MMMM YYYY");
                    break;
                default:
                    console.error("dataMappingService.mapTime: Bad tab paramater!");
                    return undefined;
            }
        };

        /**
         *  @function ReadyAppHC.graphMapProvider.mapRange
         *  @description Maps the data point at a given transform on the x-axis.
         *  @param {number} tx The transform currently being applied to the graph.
         *  @returns A data point in {@linkcode outs} that corresponds to the transform.
         */
        this.mapRange = function(tx) {
            if (needsParams) {
                console.error("dataMappingService.mapRange: Needs mapping paramaters!");
                return undefined;
            }
            if (tx > _max || tx < _min) {
                console.error("dataMappingService.mapRange: Transform out of range!");
                return undefined;
            }

            var index = (_data.length - Math.floor((tx + Math.abs(Math.min(_min, _max))) / _delta)) - 1;     
            if (index < 0) {
                index = 0;
            }

            // If the number is more than 100000, redo it in shorthand format
            var ret = _data[index].y;
            if (ret >= 1000000) {
                ret = (ret / 1000000).toFixed(2) + "M";
            }
            return ret;
        };
    };
    
    return graphMap;
});