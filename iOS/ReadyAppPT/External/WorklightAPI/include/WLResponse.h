/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLResponse.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 3/7/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLProcedureInvocationResult.h"

/**
 * @ingroup main
 *
 * This class contains the result of a procedure invocation. IBM MobileFirst Platform passes this class as an argument to the
 * delegate methods of WLClient invokeProcedure methods.
 */
@interface WLResponse : NSObject {
	int status;
	WLProcedureInvocationResult *invocationResult;
	NSObject *invocationContext;
	NSString *responseText;
}

/**
 * Retrieves the HTTP status from the response.
 */
@property (nonatomic) int status;

/**
 * The response data from the server.
 */
@property (nonatomic, strong) WLProcedureInvocationResult *invocationResult;

/**
 * The invocation context object passed when calling invokeProcedure.
 */
@property (nonatomic, strong) NSObject *invocationContext;

/**
 * The original response text from the server.
 */
@property (nonatomic, strong) NSString *responseText;


/**
 * This method returns the value NSDictionary in case the response is a JSON response, otherwise it returns the value nil. NSDictionary represents the root of the JSON object.
 *
 **/
-(NSDictionary *)getResponseJson;

@end
