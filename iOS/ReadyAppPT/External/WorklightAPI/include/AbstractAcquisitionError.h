/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractAcquisitionError_H_
#import <Foundation/Foundation.h>

@interface AbstractAcquisitionError : NSObject {
	@public /*protected in Java*/
	NSString* message;
}



- (id) init : (NSString*) message ;
/**
	 * @return the message for the error.
	 */
- (NSString*) getMessage  ;
- (NSObject*) getErrorCode  ;

@end

