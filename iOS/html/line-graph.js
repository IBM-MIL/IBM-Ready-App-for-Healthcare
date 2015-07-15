/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

/**
 *  @class ReadyAppHC.lineGraph
 *  @memberOf ReadyAppHC
 *  @description A directive that defines a line graph in Physio. This directive must exist in a
 *  descendent of {@linkcode milSyncedGraphCtrl} in order to function correctly. This graph is also decorated
 *  with three attributes: {@linkcode consume}, a reference to a function that returns JSON data that this 
 *  graph needs to display, {@linkcode transform}, a reference to the shared transformation integer that should 
 *  be applied to the x-axis on all graphs within the parent controller, and {@linkcode unit}, a string that    
 *  describes the units that this graph is displaying in (ex: bpm, lbs, kcal, etc.).
 *  @example
 *  <line-graph consume="func()" transform="data.xData" unit="lbs"></line-graph> 
 *  @author Jonathan Ballands
 *  @author Blake Ball
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */
angular.module('ReadyAppHC').directive('lineGraph', function(graphMapFactory, choreographerService) {

    return {
        
        restrict: 'E',
        
        scope: { 
            consume: '&',
            transform: '=',
            unit: '@'
        },
        
        templateUrl: 'graph.html',
        
        link: function(scope, element, attrs) {
            
            /*
             * Variable setup
             */
            
            var ready = false;

            var mapper = new graphMapFactory();

            var width = element[0].offsetWidth,
                height = element[0].offsetHeight;

            var x = d3.scale.linear();

            var y = d3.scale.linear();
            
            var basis = undefined;

            /*
             *  Define some public values.
             */
            scope.tx = undefined;
            scope.val = undefined;
            scope.time = undefined;

            /* 
             *  Define the zoom behavior.
             */
            var zoom = d3.behavior.zoom()
                .x(x)
                .scaleExtent([1, 1]);

            /*
             *  Define the SVG where everything will exist.
             */
            var svg = d3.select(element[0]).append("svg")
                .attr("class", "chart")
                .attr("width", width)
                .attr("height", height)
                .call(zoom);
                
            var lineGroup = svg.append("g")
                .attr("class", "line-group")
                .style("display", "inline-block");

            /*
             *  Listen for zoom events with D3.
             */
            zoom.on("zoom", function() {

                // Left side bound
                var a = zoom.translate()[0];
               a = Math.min(a, width / 2);

                // Right side bound
                var graphWidth = d3.select(".line-group")
                    [0][0].getBBox().width;
                a = Math.max(a, width - graphWidth - width / 2 + 6);

                // Apply the basis vector
                scope.tx = a - basis;
                
                scope.$apply(function() {
                    scope.transform.xGraph = scope.tx;
                });

                // NOTE: You need to put the translate function here, as well as in the 
                // listener, preventing athe zoom behavior from registering touches after
                // the graph has already hit its bounds.
                zoom.translate([a, zoom.translate()[1]]);
            });

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
                
                zoom.translate([dx, zoom.translate()[1]]);
                lineGroup.attr("transform", "translate(" + dx + ",0)");
                scope.tx = scope.transform.xGraph;
                
                if (ready) {    
                    scope.val = mapper.mapRange(scope.tx);
                    scope.time = mapper.mapTime(scope.tx);
                }
            });

            /*
             *  Listen for invalidate_graph broadcasts.
             *
             *  Called when data needs to be injected into the graph.
             */
            scope.$on('invalidate_graph', function(e, arg) {
                
                // Kill all svg elements before redrawing
                svg.selectAll("path").remove();
                svg.selectAll("circle").remove();
                
                var json = JSON.parse(scope.consume());
                
                x.domain(json.map(function(d) { return d.x; }));
                x.range(json.map(function(d) { return (d.x - 1) * choreographerService.delta; }));
                
                _yMin = d3.min(json.map(function(d) { return d.y; }));
                _yMax = d3.max(json.map(function(d) { return d.y; }));
                y.domain([_yMin, _yMax]);
                y.range([height - 6, 40]);
                
                // Edge case: if all the values are the same, then the range should be very restricted
                var _bumper = 0;
                if(_yMin == _yMax) {
                    if (_yMin == 0) {
                        _bumper = 0;
                    } else {
                        _bumper = ((height - 6) - 40) / 2;
                    }
                }

                
                var line = d3.svg.line()
                    .x(function(d) { return x(d.x) })
                    .y(function(d) { return y(d.y) - _bumper });
                
                lineGroup.selectAll("path")
                    .data([json])
                    .enter().append("path")
                    .attr("d", d3.svg.line()
                        .x(function(d) { return x(d.x) })
                        .y(function(d) { return y(d.y) - _bumper })
                    );
                
                lineGroup.selectAll("circle")
                    .data(json)
                    .enter().append("circle")
                    .attr('cx', function(d) { return x(d.x) })
                    .attr('cy', function(d) { return y(d.y) - _bumper })
                    .attr('r', 4);

                var graphWidth = d3.select(".line-group")
                        [0][0].getBBox().width;
                var start = width - graphWidth - width / 2 + 6;
                
                // Let choreographer know about the new graph width so that the time graph can draw properlly
                choreographerService.graphWidth = graphWidth;

                zoom.translate([start, zoom.translate()[1]]);
                lineGroup.attr("transform", "translate(" + start + ",0)");
                basis = start;
                scope.tx = 0;
                
                var _max = (width / 2) + Math.abs(width - graphWidth - width / 2 + 6);

                mapper.setParams(0, _max, json, choreographerService.tab);
                scope.val = mapper.mapRange(scope.tx);
                scope.time = mapper.mapTime(scope.tx);

                // Get Angular to digest to finish redraw
                scope.$digest();
                ready = true;
            });
        }
    };
});