/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.choreographerService
 *  @memberOf ReadyAppHC
 *  @description An Angular service that handles the creation of a so-called {@linkcode delta} value that is
 *  used by graph directives ({@linkcode bar-graph}, {@linkcode line-graph}, and {@linkcode time-graph}) to 
 *  determine the appropriate range for the x-axis, depending on the selected tab. In other words,
 *  this service creates a number called {@linkcode delta} that is used by graph directives to space the
 *  x-values out so that graphs with more data are more crowded and graphs with less data are less crowded.
 *
 *  @property {integer} delta The {@linkcode delta} value that defines the appropriate range for the x-axis, depending on the selected tab.
 *
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').service('choreographerService', function() {
    
    var day = {tab: 48, delta: 12};
    var week = {tab: 14, delta: 40};
    var month = {tab: 8, delta: 90};
    var year = {tab: 24, delta: 35};
    
    this.delta = day.delta;
    this.tab = day.tab;
    this.graphWidth = 0;
    this.barWidth = 6;
    
    /**
     *  @function ReadyAppHC.choreographerService.notify
     *  @description Notifies this service that it should generate a new {@linkcode delta} value because
     *  a new tab was pressed.
     *  @param {integer} tab The integer value specified in {@linkcode milTabbedGraphCtrl} that lets this
     *  service know what tab the {@linkcode delta} should be generated for.
     */
    this.notify = function(tab) {
        switch(tab) {
            case day.tab:
                this.delta = day.delta;
                break;
            case week.tab:
                this.delta = week.delta;
                break;
            case month.tab:
                this.delta = month.delta;
                break;
            case year.tab:
                this.delta = year.delta;
                break;
        };
        this.tab = tab;
    };
    
});
