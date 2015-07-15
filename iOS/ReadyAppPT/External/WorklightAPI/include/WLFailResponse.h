/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLFailResponse.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 6/17/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLResponse.h"

typedef enum {
    WLErrorCodeUnexpectedError,
    WLErrorCodeUnresponsiveHost,
    WLErrorCodeRequestTimeout,
    WLErrorCodeProcedureError,
	WLErrorCodeApplicationVersionDenied,
	WLErrorCodeApplicationVersionNotify
} WLErrorCode;

/**
 * @ingroup main
 *
 * Derived from WLResponse, containing error codes and messages in addition to the status in WLResponse. 
 * Contains the original response data object from the server as well.
 */
@interface WLFailResponse : WLResponse {
	WLErrorCode errorCode;
	NSString *errorMsg;
	
}

/**
 * The possible errors are described in the WLErrorCode section.
 * The HYPERLINK <a href="_Enum_WLErrorCode" \o "http://wiki.worklight.com/index.php/IphoneSDK#WLErrorCode"> link WLErrorCode </a>section contains a description of possible error codes.
 */
 @property (nonatomic) WLErrorCode errorCode;

/**
 * An error message for the developer, which is not necessarily suitable for displaying to the end user.
 */
@property (nonatomic, strong) NSString *errorMsg;


/**
 * This method returns a string message from a WLErrorCode.
 *
 **/
+(NSString *) getErrorMessageFromCode: (WLErrorCode) code;

/**
 * This method returns an error message from the JSON response.
 *
 **/
+(NSString *) getErrorMessageFromJSON: (NSDictionary *) jsonResponse;

/**
 * This method returns the WLErrorCode from the JSON response.
 *
 **/
+(WLErrorCode) getWLErrorCodeFromJSON: (NSDictionary *) jsonResponse;



@end
