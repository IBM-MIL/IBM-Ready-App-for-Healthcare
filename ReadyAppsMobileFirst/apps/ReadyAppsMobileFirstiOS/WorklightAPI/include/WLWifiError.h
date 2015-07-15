/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiError_H_
#import "AbstractAcquisitionError.h"

typedef enum {
	PERMISSION, 
	DISABLED, 
	FAILED_START_SCAN
} WLWifiErrorCodes;


/**
 * @ingroup geo
 * An error that occurred during WiFi acquisition
 */
@interface WLWifiError : AbstractAcquisitionError {
	@private
	WLWifiErrorCodes code;
}



/**
	 * @param code The error code
	 * @param message The error's message
	 */
- (id)initWithErrorCode:(WLWifiErrorCodes)code message:(NSString*)message;
/**
	 * @return the error code
	 */
- (WLWifiErrorCodes) getErrorCode  ;

@end

