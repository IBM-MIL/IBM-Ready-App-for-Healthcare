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
        templateUrl: 'views/dashboard.html',
        controller: 'dashboardCtrl'
    });
    
    /*
     *  Metrics Controller
     */
    $routeProvider.when('/WebView/metrics', {
        templateUrl: 'views/metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_day', {
        templateUrl: 'views/metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_week', {
        templateUrl: 'views/metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_month', {
        templateUrl: 'views/metrics.html',
        controller: 'metricsCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_year', {
        templateUrl: 'views/metrics.html',
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
        templateUrl: 'views/metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_day', {
        templateUrl: 'views/metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_week', {
        templateUrl: 'views/metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_month', {
        templateUrl: 'views/metrics-steps.html',
        controller: 'metricsStepsCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_steps_year', {
        templateUrl: 'views/metrics-steps.html',
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
        templateUrl: 'views/metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_day', {
        templateUrl: 'views/metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_week', {
        templateUrl: 'views/metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_month', {
        templateUrl: 'views/metrics-hr.html',
        controller: 'metricsHrCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_hr_year', {
        templateUrl: 'views/metrics-hr.html',
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
        templateUrl: 'views/metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_day', {
        templateUrl: 'views/metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_week', {
        templateUrl: 'views/metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_month', {
        templateUrl: 'views/metrics-weight.html',
        controller: 'metricsWeightCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_weight_year', {
        templateUrl: 'views/metrics-weight.html',
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
        templateUrl: 'views/metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_day', {
        templateUrl: 'views/metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_week', {
        templateUrl: 'views/metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_month', {
        templateUrl: 'views/metrics-calories.html',
        controller: 'metricsCaloriesCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_calories_year', {
        templateUrl: 'views/metrics-calories.html',
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
        templateUrl: 'views/metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_day', {
        templateUrl: 'views/metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 48;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_week', {
        templateUrl: 'views/metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 14;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_month', {
        templateUrl: 'views/metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 8;
            }
        }
    });
    $routeProvider.when('/WebView/metrics_pain_year', {
        templateUrl: 'views/metrics-pain.html',
        controller: 'metricsPainCtrl',
        resolve: {
            tab: function() {
                return 24;
            }
        }
    });
}]);