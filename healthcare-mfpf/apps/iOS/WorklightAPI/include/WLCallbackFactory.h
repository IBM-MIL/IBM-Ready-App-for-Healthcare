/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLCallbackFactory.h
//  WorklightStaticLibProject
//
//  Created by Dolev Dotan on 10/30/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WLTriggerCallback;
@protocol WLGeoCallback;
@protocol WLGeoFailureCallback;
@protocol WLWifiConnectedCallback;
@protocol WLWifiFailureCallback;
@protocol WLDeviceContext;
@class    WLGeoError;
@class    WLWifiError;
@class    WLGeoPosition;
@class    WLWifiAccessPoint;


/**
 * A utility class that allows using blocks wherever a callback object is needed in the IBM MobileFirst Platform Location Services API.
 */
@interface WLCallbackFactory : NSObject

/**
* This method creates a trigger callback that wraps the given block.
*
* @param callbackBlock The block that will be delegated to by the returned WLGeoCallback instance.
**/
+ (id<WLTriggerCallback>)       createTriggerCallback:       (void (^)(id<WLDeviceContext> deviceContext)) callbackBlock;


/**
 * This method creates a geo callback that wraps the given block.
 *
 * @param callbackBlock The block that will be delegated to by the returned WLGeoCallback instance.
 **/
+ (id<WLGeoCallback>)           createGeoCallback:           (void (^)(WLGeoPosition* pos))                callbackBlock;

/**
 * This method creates a WiFi connected callback that wraps the given block.
 *
 * @param callbackBlock The block that will be delegated to by the returned WLGeoCallback instance.
 **/
+ (id<WLWifiConnectedCallback>) createWifiConnectedCallback: (void (^)(WLWifiAccessPoint* connectedAccessPoint, NSNumber* signalStrength)) callbackBlock;

/**
 * This method creates a geo failure callback that wraps the given block.
 *
 * @param callbackBlock The block that will be delegated to by the returned WLGeoCallback instance.
 **/
+ (id<WLGeoFailureCallback>)    createGeoFailureCallback:    (void (^)(WLGeoError* error))                 callbackBlock;

/**
 * This method creates a WiFi failure callback that wraps the given block.
 *
 * @param callbackBlock The block that will be delegated to by the returned WLGeoCallback instance.
 **/
+ (id<WLWifiFailureCallback>)   createWifiFailureCallback:   (void (^)(WLWifiError* error))                callbackBlock;

@end
