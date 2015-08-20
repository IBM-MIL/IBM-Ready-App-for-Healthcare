/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.timeGraph
 *  @memberOf ReadyAppHC
 *  @description A directive that defines a time graph is Physio. The time graph is the small gray bar
 *  above a graph that depicts the time domain for the bar and line graphs.
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */

angular.module('ReadyAppHC').directive('timeGraph', function(choreographerService) {

    return {
        
        restrict: 'E',
        
        scope: {
            datalength: '@',
            transform: '='
        },
        
        link: function(scope, element, attrs) {
             
            /*
             * Variable setup
             */

            var width = element[0].offsetWidth,
                height = element[0].offsetHeight;

            var x = d3.scale.linear();

            var y = d3.scale.linear();
            
            var basis = undefined;

            /*
             *  Define a translation value.
             */
            scope.tx = undefined;

            /*
             *  Define the SVG where everything will exist.
             */
            var svg = d3.select(element[0]).append("svg")
                .attr("class", "chart")
                .attr("width", width)
                .attr("height", height);
                
            var textGroup = svg.append("g")
                .attr("class", "text-group")
                .style("display", "inline-block");

            /*
             *  Listen for transform_graph broadcasts.
             *
             *  Called when the graph needs to be dragged left or right.
             */
            scope.$watch('transform.xGraph', function() {
                // NOTE: You must call D3's translate function on the zoom behavior in order
                // for D3 to "recognize" where the graph exists, as well as perform a
                // transform and each individual bar in the bar graph in order to visually
                // see a change.
                var dx = scope.transform.xGraph + basis;
                textGroup.attr("transform", "translate(" + dx + ",0)");
                scope.tx = scope.transform.xGraph;
            });

            /*
             *  Listen for invalidate_graph broadcasts.
             *
             *  Called when data needs to be injected into the graph.
             */
            scope.$on('invalidate_graph', function(e, arg) {
                
                // Kill all svg elements before redrawing
                svg.selectAll("text").remove();
                
                // Parse integers
                scope.datalength = parseInt(scope.datalength);
                
                // Assemble an array of data that we want to display
                var tab = choreographerService.tab;
                var skip = 1;
                var unit = undefined;
                var format = undefined;
                switch(tab) {
                    case 48:
                        unit = 'hours';
                        format = 'h';
                        skip = 3;
                        break;
                    case 14:
                        unit = 'days';
                        format = 'dd';
                        break;
                    case 8:
                        unit = 'weeks';
                        format = 'MMM D';
                        break;
                    case 24:
                        unit = 'months';
                        format = 'MMM';
                        break;
                    default:
                        console.warn("time-graph: Bad tab paramater!");
                        unit = 'hours';
                        format = 'h';
                        skip = 3;
                }
                var d = moment.duration(0, unit);
                
                // Loop variables
                var data = [];
                var now = moment();
                var accumulatorTime = now.subtract(d.add(scope.datalength - 1, unit), unit);
                var accumulatorPeriod = now.format('a');
                
                // Subtract 1 more unit if we are on the month tab
                if (tab == 8) {
                    accumulatorTime.subtract(1, "week");
                    accumulatorTime.subtract(scope.datalength - 1, "days");
                }
                
                // Place a point down until we hit the desired width (data creation)
                for (var i = 0 ;  i < scope.datalength ; i = i + skip) {
                    
                    // There is a slight exception where, if you are in the day tab, 12 should be AM or PM
                    if (tab == 48 && accumulatorPeriod !== accumulatorTime.format('a')) {
                        data.push({"x": i, "y": accumulatorTime.format('A')});
                    }
                    else if (tab == 8) {
                        var stringBuilder = accumulatorTime.format(format);
                        var tempTime = accumulatorTime.clone();
                        stringBuilder = stringBuilder + "-" + tempTime.add(1, unit).format(format);
                        data.push({"x": i, "y": stringBuilder});
                        
                        // Add 1 day so that the dates don't overlap
                        accumulatorTime.add(1, "day");
                    }
                    else {
                        data.push({"x": i, "y": accumulatorTime.format(format)});
                    }
                    accumulatorPeriod = accumulatorTime.format('a');
                    accumulatorTime = accumulatorTime.add(skip, unit);
                }
                
                x.domain(data.map(function(d) { return d.x; }));
                x.range(data.map(function(d) { return (d.x * choreographerService.delta); }));

                textGroup.selectAll(".tick")
                    .data(data)
                    .enter().append("text")
                    .text(function(d) { return data[d.x / skip].y; })
                    .attr("class", "tick")
                    .attr("x", function(d) { return x(d.x + 1); })
                    .attr("y", 22)
                    .attr("color", "#4D4E4E")
                    .attr("font-family", "Roboto-Medium")
                    .attr("font-size", 12)
                    .attr("text-anchor", "middle");
                
                // Add a slight shift for the bar graph due to the bar width, if needed
                if (tab == 48) {
                    svg.selectAll(".tick").attr("x", function(d) { 
                        return x(d.x + 1) - choreographerService.barWidth / 2 
                    });
                }
                
                // The graph width should be based on the deltas, not the widths of the text tags
                var graphWidth = choreographerService.delta * scope.datalength;
                var start = width - graphWidth - width / 2;
                
                textGroup.attr("transform", "translate(" + start + ",0)");
                
                basis = start;
                scope.tx = 0;

                // Get Angular to digest to finish redraw
                scope.$digest();
            });
        }
    };
});