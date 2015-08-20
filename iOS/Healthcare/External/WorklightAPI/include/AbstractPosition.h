/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractPosition_H_
#import <Foundation/Foundation.h>

/**
 * A parent class for position
 */
@interface AbstractPosition : NSObject {
	@private
	NSNumber* timestamp;
}



- (id) init : (long long) timestamp ;
- (id) init  ;
/**
	 * @return the time when this position was acquired (number of milliseconds elapsed since Jan 1, 1970).
	 */
- (NSNumber*) getTimestamp  ;
/**
	 * @exclude
	 * for testing purposes only!
	 */
- (void) setTimestamp : (long long) timestamp ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

