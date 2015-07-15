/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

readyApp.config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      
    /*
     *  Dashboard
     */
    $routeProvider.when('/WebView/dashboard', {
        templateUrl: 'dashboard.html',
        controller: 'dashboardCtrl'
    });
    
    /*
     *  Metrics Controller
     */
    $routeProvider.when('/WebView/metrics', {
        templateUrl: 'metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_day', {
        templateUrl: 'metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_week', {
        templateUrl: 'metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_month', {
        templateUrl: 'metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_year', {
        templateUrl: 'metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
    
    /*
     *  Metrics Steps Controller
     */
    
    $routeProvider.when('/WebView/metrics_steps', {
        templateUrl: 'metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_day', {
        templateUrl: 'metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_week', {
        templateUrl: 'metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_month', {
        templateUrl: 'metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_year', {
        templateUrl: 'metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
    
    /*
     *  Metrics Hr Controller
     */
    
    $routeProvider.when('/WebView/metrics_hr', {
        templateUrl: 'metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_day', {
        templateUrl: 'metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_week', {
        templateUrl: 'metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_month', {
        templateUrl: 'metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_year', {
        templateUrl: 'metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
    
    /*
     *  Metrics Weight Controller
     */
    
    $routeProvider.when('/WebView/metrics_weight', {
        templateUrl: 'metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_day', {
        templateUrl: 'metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_week', {
        templateUrl: 'metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_month', {
        templateUrl: 'metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_year', {
        templateUrl: 'metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
    
    /*
     *  Metrics Calories Controller
     */
    
    $routeProvider.when('/WebView/metrics_calories', {
        templateUrl: 'metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_day', {
        templateUrl: 'metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_week', {
        templateUrl: 'metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_month', {
        templateUrl: 'metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_year', {
        templateUrl: 'metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
    
    /*
     *  Metrics Pain Controller
     */
    
    $routeProvider.when('/WebView/metrics_pain', {
        templateUrl: 'metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_day', {
        templateUrl: 'metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_week', {
        templateUrl: 'metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_month', {
        templateUrl: 'metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_year', {
        templateUrl: 'metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
}]);