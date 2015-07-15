/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLProcedureInvocationResult.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 6/29/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup main
 *
 * This class contains the result of calling a back-end service, including statuses and data items that the adapter function retrieves from the server.
 */
@interface WLProcedureInvocationResult : NSObject {

		
	@private 
	NSMutableDictionary *response;
	NSDictionary *result;
	NSMutableArray *recordNames;
	NSArray *errors;
	NSArray *warnings;
	NSArray *info;
	NSNumber *success;
}

/**
 * This property is an NSDictionary, which represents the JSON response that the IBM MobileFirst Platform Server returns.
 *
 **/
@property (nonatomic, readonly) NSDictionary *response;


-(id)initWithInvocationResultDictionary:(NSDictionary *)theResult;

/**
 * This method returns YES if the call was successful, and NO otherwise.
 *
 **/
-(BOOL)isSuccessful;

/**
 * This method returns an NSArray of applicative error messages that the server collects during the procedure call.
 *
 **/
-(NSArray *)procedureInvocationErrors;

-(NSArray *)warnMessages;
-(NSArray *)infoMessages;
@end
