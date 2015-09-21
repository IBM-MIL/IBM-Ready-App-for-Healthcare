/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiVisibleAccessPointsChangeTrigger_H_
#import "WLWifiTrigger.h"
@class WLWifiAcquisitionPolicy;
@protocol WLTriggerCallback;

/**
 * @ingroup geo
 * A trigger for tracking changes to the visible access points.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls.
 */
@interface WLWifiVisibleAccessPointsChangeTrigger : WLWifiTrigger {
}

/**
 * This method initializes the trigger definition.
 */
- (id) init  ;
- (BOOL) validate : (WLWifiAcquisitionPolicy*) policy ;
- (WLWifiVisibleAccessPointsChangeTrigger*) clone  ;

/**
 * This method sets the callback, whose execute method is called when the trigger is activated.
 * @param callbackFunction The callback the user wants to set. This parameter must conform to the WLTriggerCallback protocol.
 * When the trigger is activated, its execute method will be called and the current device context is passed as a parameter.
 * @return A reference to this object.
 */
- (WLWifiVisibleAccessPointsChangeTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;

/**
 * This method sets the event to be transmitted to the server.
 * @param event The event the user wants to set.
 * @return A reference to this object.
 */
- (WLWifiVisibleAccessPointsChangeTrigger*) setEvent : (NSMutableDictionary*) event ;

/**
 * This method determines whether the event is transmitted immediately, or whether it is transmitted according to the transmission policy.
 * If the value is true, the event is added to the transmission buffer, and the contents of the transmission buffer are flushed to the server.
 * Otherwise the event is added only to the transmission buffer.
 * @param transmitImmediately A Boolean value that determines whether the event is transmitted immediately.
 * @return A reference to this object.
 */
- (WLWifiVisibleAccessPointsChangeTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;

@end

