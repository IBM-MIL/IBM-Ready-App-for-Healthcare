/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLEventTransmissionPolicy_H_
#import <Foundation/Foundation.h>

/**
 * @ingroup geo
 * The event transmission policy is used to control how events are transmitted to the server.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls. 
 */
@interface WLEventTransmissionPolicy : NSObject  <NSCopying> {
	@private
// default values 
	BOOL eventStorageEnabled;
	long long interval;
	int maxChunkSize;
	int maxMemSize;
	long long retryInterval;
	int numRetries;
}


- (id) init  ;

/**
 * This method returns a new policy, with all fields set to default values.
 *
 * @param None.
 * @return A new policy with all fields set to default values.
 **/
+ (WLEventTransmissionPolicy*) getDefaultPolicy  ;

/**
 * This method returns a Boolean value indicating whether events can be stored persistently. If events can be stored persistently, the value true is returned; otherwise, false is returned. The default value is false.
 *
 * @param None.
 * @return <code>true</code> if events can be stored persistently, otherwise <code>false</code>. By default, is <code>false</code>.
 **/
- (BOOL) isEventStorageEnabled  ;

/** 
     * This method receives a Boolean value that determines where events are stored. If the value is <code>true</code>, events may be stored persistently. If the
	 * value is <code>false</code>, events that are waiting for transmission are stored in memory. The default value is
	 * <code>false</code>.
	 * 
	 * @param eventStorageEnabled The value to set.
	 * @return A reference to this object.
	 */
- (WLEventTransmissionPolicy*) setEventStorageEnabled : (BOOL) eventStorageEnabled ;

/**
 * This method returns the transmission interval, in milliseconds.
 *
 * @param None.
 * @return the transmission interval, in milliseconds.
 **/
- (long long) getInterval  ;

/**
	 * Sets the transmission interval, in milliseconds. The default value is 60000 (one minute). Before events are
	 * transmitted, they are accumulated in memory and/or storage.
	 * 
	 * @param interval the interval to set
	 * @return A reference to this object.
	 */

- (WLEventTransmissionPolicy*) setInterval : (long long) interval ;
/**
	 * @exclude
	 * @return the maximumMemorySize in kilobytes
	 */
- (int) getMaxMemSize  ;
/**
	 * @exclude
	 * @param maximumMemorySize the maximumMemorySize to set in kilobytes
	 * @return A reference to this object.
	 */
- (WLEventTransmissionPolicy*) setMaxMemSize : (int) maximumMemorySize ;
/**
	 * @exclude
	 * @return the maximumChunkSize in kilobytes
	 */
- (int) getMaxChunkSize  ;
/**
	 * @exclude
	 * @param maximumChunkSize the maximumChunkSize to set in kilobytes
	 * @return A reference to this object.
	 */
- (WLEventTransmissionPolicy*) setMaxChunkSize : (int) maximumChunkSize ;
/**
	 * @exclude
	 * @return the retry interval
	 */
- (long long) getRetryInterval  ;
/**
	 * @exclude
	 * @param retryInterval the retry interval to set
	 * @return A reference to this object.
	 */
- (WLEventTransmissionPolicy*) setRetryInterval : (long long) retryInterval ;
/**
	 * @exclude
	 * @return the number of retries on failure
	 */
- (int) getNumRetries  ;
/**
	 * @exclude
	 * @param numRetries Set the number of retries on failure
	 * @return A reference to this object.
	 */
- (WLEventTransmissionPolicy*) setNumRetries : (int) numRetries ;
- (WLEventTransmissionPolicy*) clone  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

