/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLDelegate.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 8/22/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLResponse.h"
#import "WLFailResponse.h"

/**
 * @ingroup main
 *
 * A protocol that defines methods that a delegate for the WLClient invokeProcedure method should implement,
 * to receive notifications about the success or failure of the method call.
 */
@protocol WLDelegate <NSObject>

/**
 * 
 * This method will be called upon a successful call to WLCLient invokeProcedure with the WLResponse containing the
 * results from the server, along with any invocation context object and status.
 *
 * @param response contains the results from the server, along with any invocation context object and status.
 **/
-(void)onSuccess:(WLResponse *)response;

/**
 * 
 * This method will be called if any kind of failure occurred during the execution of WLCLient invokeProcedure.
 *
 * @param response contains the error code and error message, and optionally the results from the server,along with any invocation context object and status. 
 **/
-(void)onFailure:(WLFailResponse *)response;

@end
