/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLPush.h
//  WorklightStaticLibProject
//
//  Created by worklightdev on 24/01/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLClient.h"
#import "WLOnReadyToSubscribeListener.h"
#import "WLEventSourceListener.h"
#import "WLDelegate.h"
#import "WLPushOptions.h"

/**
 * @ingroup push
 * This class exposes all the methods that are required for push notifications.
 */
@interface WLPush : NSObject

@property (strong) id <WLOnReadyToSubscribeListener> onReadyToSubscribeListener;
@property (strong) NSMutableDictionary *registeredEventSources;
@property (strong) NSString *serverToken;
@property (strong) NSString *deviceToken;
@property (strong) NSMutableArray *subscribedEventSources;
@property (strong) NSMutableArray *subscribedTags;
@property (strong) NSString *tokenFromClient;
@property  BOOL isTokenUpdatedOnServer;

+(WLPush *) sharedInstance;

/**
 * This method sets the OnReadyToSubscribeListener callback to be notified when the device is ready to subscribe to push notifications.
 *
 * @param OnReadyToSubscribeListener Mandatory. When the device is ready to subscribe to push notifications, the onReadyToSubscribe method is called.
 **/
-(void) setOnReadyToSubscribeListener:(id <WLOnReadyToSubscribeListener>)listener;

/**
 * This method registers an EventSourceListener that is called whenever a notification arrives from the specified event source.
 *
 * @param alias Mandatory string. A short ID that you use to identify the event source when the push notification arrives. You can provide a short alias, rather than the full names of the adapter and event source. This action frees space in the notification text, which is usually limited in length.
 * @param adapter Mandatory string. The name of the adapter that contains the event source.
 * @param eventSource Mandatory string. The name of the event source.
 * @param eventSourceListener Mandatory listener class. When a notification arrives, the EventSourceListener.onReceive method is called.
 **/
-(void) registerEventSourceCallback:(NSString *)alias :(NSString *)adapter :(NSString *)eventsource :(id <WLEventSourceListener>)eventSourceListener;

-(BOOL)isAbleToSubscribe :(NSString * )alias :(BOOL)isRegistering;

-(BOOL)isAbleToSubscribeTag :(NSString * )tagName;

-(void) updateToken :(NSString *)svrToken;

-(void) updateTokenCallback :(NSString *)deviceToken;

-(void) clearSubscribedEventSources;

-(void) clearSubscribedTags;

-(void) updateSubscribedEventSources :(NSDictionary *) eventSources;

-(void) updateSubscribedTags :(NSDictionary *) tags;

/**
* This method subscribes the user to the event source with the specified alias.
*
* @param alias Mandatory string. The event source alias, as defined in registerEventSourceCallback.
* @param options Optional. This instance contains the custom subscription parameters that the event source in the adapter supports.
* @param responseListener Optional. The listener object, whose callback methods, onSuccess and onFailure, are called.
**/
-(void) subscribe :(NSString *)alias :(WLPushOptions *)options : (id <WLDelegate>)responseListener;


/**
 * This method subscribes the device to the tag.
 *
 * @param tagName Mandatory string. Name of the tag.
 * @param options Optional. This instance contains the custom subscription parameters that the event source in the adapter supports.
 * @param responseListener Optional. The listener object, whose callback methods, onSuccess and onFailure, are called.
 **/
-(void) subscribeTag :(NSString *)tagName :(WLPushOptions *)options : (id <WLDelegate>)responseListener;


/**
 * This method unsubscribes the user from the event source with the specified alias.
 *
 * @param alias Mandatory string. The event source alias, as defined in registerEventSourceCallback.
 * @param responseListener Optional. The listener object, whose callback methods, onSuccess and onFailure, are called.
 **/
-(void) unsubscribe :(NSString *)alias :(id <WLDelegate>)responseListener;

/**
 * This method unsubscribes the device from the tag.
 *
 * @param tagName Mandatory string. Name of the tag.
 * @param responseListener Optional. The listener object, whose callback methods, onSuccess and onFailure, are called.
 **/
-(void) unsubscribeTag :(NSString *)tagName : (id <WLDelegate>)responseListener;


/**
 * This method returns whether the currently logged-in user is subscribed to the specified event source alias.
 *
 * @param alias Mandatory string. The event source alias
 * @return returns whether logged-in user is subscribed or not.
 **/
-(BOOL) isSubscribed :(NSString *)alias;

/**
 * This method returns whether the device is subscribed to the specified tag.
 *
 * @param tagName Mandatory string. Name of the tag.
 * @return returns whether the device is subscribed to the specified tag.
 **/
-(BOOL) isTagSubscribed :(NSString *)tagName;

/**
 * This method checks whether push notification is supported.
 *
 * @return returns whether push notification is supported.
 **/
-(BOOL)isPushSupported;

-(void) internalSubscribe :(WLPushOptions *)options :(BOOL )isTag :(NSString *)name :(id <WLDelegate>)responseListener;

-(void) internalUnsubscribe :(BOOL )isTag :(NSString *)name :(id <WLDelegate>)responseListener;

@end
