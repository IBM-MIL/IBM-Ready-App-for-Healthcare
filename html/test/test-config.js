/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty 
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to 
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part 
 *  of such an application, in customer's own products.
 */

module.exports = function(config) {
  config.set({
    basePath: '',
      
    frameworks: ['jasmine'],
      
    files: [
        // Vendor
        '../js/bower_components/angular/angular.js',
        '../js/bower_components/angular-mocks/angular-mocks.js',
        '../js/bower_components/angular-route/angular-route.js',
        '../js/bower_components/angular-touch/angular-touch.js',
        '../js/bower_components/moment/min/moment-with-locales.js',
        '../js/vendor/angular-translate.js',
        
        // Src
        '../js/src/*.js',
        '../js/src/**/*.js',
        
        // Specs
        './spec/**/*.js'
    ],
        
    exclude: [
    ],
      
    preprocessors: {
    },
      
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome', 'Safari'],
    singleRun: true,
      
    client: {
        captureConsole: false
    }
  });
};
