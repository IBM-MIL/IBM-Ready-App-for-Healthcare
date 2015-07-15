/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLProcedureInvocationData.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 3/9/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup main
 * 
 * This class holds all data necessary for invoking a procedure, including:
 * 1) The name of the adapter and procedure to invoke
 * 2) Parameters required by the procedure
 */
@interface WLProcedureInvocationData : NSObject {
	@private NSString *adapter;
	NSString *procedure;
	
	// Array of primitive types: (NSString, NSNumber) BOOL values should be created as 
	NSArray *parameters;
	BOOL compressResponse;
}

// Sets the procedure parameters
// The Array should contain Objects that can be parsed via JSON. NSString and NSNumber work best.
// For Boolean values, use [NSNumber numberWithBool:]
@property (nonatomic, strong) NSArray *parameters;

@property (nonatomic) BOOL cacheableRequest;

-(NSDictionary *)toDictionary;

// Initializes with the adapter name and the procedure name.
/**
 * This method initializes with the adapter name and the procedure name.
 *
 * @param adapter The name of the adapter.
 * @param procedureName The name of the adapter procedure.
 **/
-(id)initWithAdapterName:(NSString *)adapter procedureName:(NSString *)procedure;

/**
 * This method initializes with the adapter name and the procedure name.
 *
 * @param theAdapter The name of the adapter.
 * @param theProcedure The name of the adapter procedure.
 * @param compressResponse Specifies whether or not the response from the server must be compressed.
 **/
-(id)initWithAdapterName:(NSString *)theAdapter procedureName:(NSString *)theProcedure compressResponse:(BOOL)isCompressResponse;

/**
 * This method specifies whether or not the responses from the server must be compressed. The default value is false.
 *
 * @param isCompressResponse Specifies whether or not the response from the server must be compressed.
 **/
-(void)setCompressResponse :(BOOL)isCompressResponse;
@end
