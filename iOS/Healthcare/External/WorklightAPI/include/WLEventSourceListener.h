/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  EventSourceListener.h
//  WorklightStaticLibProject
//
//  Created by worklightdev on 24/01/13.
//  Copyright (c) 2013 odedr@worklight.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WLEventSourceListener <NSObject>

-(void)onReceive:(NSString *)props :(NSString *)payload;

@end
