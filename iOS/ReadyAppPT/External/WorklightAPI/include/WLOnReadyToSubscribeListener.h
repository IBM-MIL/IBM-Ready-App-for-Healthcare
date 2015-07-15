/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLOnReadyToSubscribeListener.h
//  WorklightStaticLibProject
//
//  Created by worklightdev on 24/01/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup push
 * WLOnReadyToSubscribeListener
 */
@protocol WLOnReadyToSubscribeListener <NSObject>

/**
 * This method is called when the device is ready to subscribe to push notifications.
 **/
-(void) OnReadyToSubscribe;

@end
