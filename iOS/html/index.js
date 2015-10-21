/* ---------------------------------------------------------------------------------- */

/*
 *  Licensed to the Apache Software Foundation (ASF) under one
 *  or more contributor license agreements.  See the NOTICE file
 *  distributed with this work for additional information
 *  regarding copyright ownership.  The ASF licenses this file
 *  to you under the Apache License, Version 2.0 (the
 *  "License"); you may not use this file except in compliance
 *  with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

var app = {
// Application Constructor
initialize: function() {
this.bindEvents();
},
// Bind Event Listeners
//
// Bind any events that are required on startup. Common events are:
// 'load', 'deviceready', 'offline', and 'online'.
bindEvents: function() {
document.addEventListener('deviceready', this.onDeviceReady, false);
},
// deviceready Event Handler
//
// The scope of 'this' is the event. In order to call the 'receivedEvent'
// function, we must explicitly call 'app.receivedEvent(...);'
onDeviceReady: function() {
app.receivedEvent('deviceready');
},
// Update DOM on a Received Event
receivedEvent: function(id) {
var parentElement = document.getElementById(id);
var listeningElement = parentElement.querySelector('.listening');
var receivedElement = parentElement.querySelector('.received');

listeningElement.setAttribute('style', 'display:none;');
receivedElement.setAttribute('style', 'display:block;');

console.log('Received Event: ' + id);
}
};

app.initialize();

/* ---------------------------------------------------------------------------------- */

/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2014. All Rights Reserved.
 *  This sample program is provided AS IS and may be used, executed, copied and modified without royalty
 *  payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to
 *  run with an IBM product, either for customer's own internal use or for redistribution by customer, as part
 *  of such an application, in customer's own products.
 */

/**
 *  @namespace ReadyAppHC
 *  @classdesc Physio is dependent on the following JavaScript libraries: [Angular]{@link https://angularjs.org/}, [D3]{@link http://d3js.org/}, and [Moment]{@link http://momentjs.com/}. Angular handles the overarching structure of the hybrid parts of Physio, D3 handles SVG manipulation, and Moment helps us parse and display dates at certain points in the application. From this point onward, this documention will assume that you understand all three of these JavaScript libraries fairly well, as well as understand the standard file structure used with these libraries. All JavaScript files live under the {@linkcode /html/js/src} directory, in which files are broken down appropriately (controllers, directives, etc). We also use [Sass]{@link http://sass-lang.com} to compile our extended CSS. All Sass files live under the {@linkcode /html/scss} directory, in which files are broken down appropriately (partials, modules, etc). Like tradiational web development, all imports are done in {@linkcode /html/index.html}. You will need to run the following Sass command in order to write in Sass: {@linkcode sass} {@linkcode --style=compressed} {@linkcode --sourcemap=none} {@linkcode -C} {@linkcode --watch} {@linkcode scss/main.scss:css/style.css}. If you are developing the hybrid portions of Physio in a browser (like Chrome, Safari, etc), you will need to run [Node]{@link http://nodejs.org/} with this command: {@linkcode node} {@linkcode test_server}.
 *  @description Defines the {@linkcode ReadyAppHC} module, as well as sets up routing for the Angular app.
 *  @author Jonathan Ballands
 *  @copyright © 2014 IBM Corporation. All Rights Reserved.
 */

'use strict';

var readyApp = angular.module('ReadyAppHC', ['ngRoute', 'ngTouch', 'pascalprecht.translate']);
