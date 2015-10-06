/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  BaseDeviceAuthChallengeHandler.h
//  WorklightStaticLibProject
//
//  Created by Ishai Borovoy on 9/13/12.
//  Base class for all device authentication classes
//

#import "BaseChallengeHandler.h"
#import "WLChallengeHandler.h"

@interface BaseDeviceAuthChallengeHandler : WLChallengeHandler
    -(void) getDeviceAuthDataAsync : (NSDictionary *) inputData;
    -(void) onDeviceAuthDataReady : (NSDictionary *) deviceData;
@end
