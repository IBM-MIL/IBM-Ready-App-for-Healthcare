/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractTrigger_H_
#import <Foundation/Foundation.h>
@protocol WLTriggerCallback;

/**
 * Defines data for triggers
 */
@interface AbstractTrigger : NSObject  <NSCopying> {
	@private
	id<WLTriggerCallback> callbackFunction;
	NSMutableDictionary* event;
	BOOL transmitImmediately;
}


- (id) init  ;
/**
	 * @return the callback object whose execute() method that will be called when the trigger is activated.
	 */
- (id<WLTriggerCallback>) getCallback  ;
/**
	 * @return The event to transmit. If <code>null</code> then it won't be transmitted.
	 * The current device context is automatically added to the event when it is transmitted.
	 */
- (NSMutableDictionary*) getEvent  ;
/**
	 * @return <code>true</code> If the event should be transmitted immediately.
	 */
- (BOOL) isTransmitImmediately  ;
/**
	 * @param callbackFunction the callback object whose execute() method will be called when the trigger is activated.
	 * @return A reference to this object.
	 */
- (AbstractTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;
/**
	 * Sets the event to be transmitted to the server.
	 * @param event the event to set. If <code>null</code> then it won't be transmitted.
	 * @return A reference to this object.
	 */
- (AbstractTrigger*) setEvent : (NSMutableDictionary*) event ;
/**
	 * @param transmitImmediately indicates whether the event should be transmitted immediately or according to the transmission policy.
	 * If its value is true, the event is added to the transmission buffer and the whole contents of the transmission buffer are flushed to the server.
	 * Otherwise the event is added only to the transmission buffer.
	 * @return A reference to this object.
	 */
- (AbstractTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;
- (NSMutableDictionary*) cloneEvent  ;
- (AbstractTrigger*) clone  ;

@end

