/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoError_H_
#import "AbstractAcquisitionError.h"

typedef enum {
	PERMISSION_DENIED, 
	POSITION_UNAVAILABLE, 
	TIMEOUT
} WLGeoErrorCodes;


/**
 * @ingroup geo
 * A <code>WLGeoError</code> object is created when an error is encountered during acquisition of a geographical position.
 */
@interface WLGeoError : AbstractAcquisitionError {
@private
	WLGeoErrorCodes errorCode;
}

/**
 * This method returns the error code and the associated message.
 * @param errorCode The error code.
 * @param message The message for the error.
 **/
- (id)initWithErrorCode:(WLGeoErrorCodes)errorCode message:(NSString*)message;


/**
 * This method returns the error code.
 *
 * @param None.
 * @return The error code
 **/
- (WLGeoErrorCodes) getErrorCode  ;

- (NSString*) description  ;

@end

