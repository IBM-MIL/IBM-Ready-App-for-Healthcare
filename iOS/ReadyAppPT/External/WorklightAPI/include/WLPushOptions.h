/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLPushOptions.h
//  WorklightStaticLibProject
//
//  Created by worklightdev on 27/01/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup push
 * 
 * This class contains the subscription parameters.
 */
@interface WLPushOptions : NSObject

@property  bool alert;
@property  bool sound;
@property  bool badge;
@property (strong) NSDictionary *parameters;


/**
 * You use this method to add a subscription parameter.
 *
 * @param name Mandatory. The name of the subscription parameter.
 * @param value Mandatory. The value of the subscription parameter.
 **/
-(void) addSubscriptionParameter :(NSString *)name :(NSString *)value;

/**
 * This method returns the map that contains the subscription parameters.
 *
 * @param name Mandatory. The name of the subscription parameter.
 * @return returns the map that contains the subscription parameters.
 **/
-(NSDictionary *) getSubscriptionParameters;

/**
 * You use this method to add a subscription parameters.
 *
 * @param parameters Mandatory. The NSDictionary that contains the list of subscription parameters.
 **/
-(void) addSubscriptionParameters :(NSDictionary *)parameters;

/**
 * This method returns the value of the given subscription parameter.
 *
 * @param name Mandatory. The name of the subscription parameter.
 * @return returns the value of the given subscription parameter.
 **/
-(NSString *) getSubscriptionParameter :(NSString *)name;

@end
