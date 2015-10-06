/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoPositionChangeTrigger_H_
#import "WLGeoTrigger.h"
@protocol WLTriggerCallback;

/**
 * @ingroup geo
 * A trigger for tracking changes in the device's position. It is possible to specify
 * a minimum distance that must be moved before the trigger will activate.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls.
 */
@interface WLGeoPositionChangeTrigger : WLGeoTrigger {
	@private
	double minChangeDistance;
}

/**
 * This method initializes the trigger definition.
 */
- (id) init  ;

/**
 * @return The sensitivity
 */
- (double) getMinChangeDistance  ;
/**
	 * After the first acquisition,  this trigger will be activated only when the reported position has changed by at least <code>minChangeDistance</code> amount.
	 * This is different from setting the parameter in {@link WLGeoAcquisitionPolicy#setMinChangeDistance(int)} as other triggers may still activate
	 * due to changes in the device's position, and no power will be saved by using this method. 
	 * @param minChangeDistance the minimum distance in meters which the position must change by in order for this trigger object to be activated.
	 * The value should be greater than that of the parameter set in {@link WLGeoAcquisitionPolicy#setMinChangeDistance(int)}, otherwise it will have no effect.
	 * @return A reference to this object
	 */
- (WLGeoPositionChangeTrigger*) setMinChangeDistance : (double) minChangeDistance ;
- (WLGeoPositionChangeTrigger*) clone  ;

/**
 * This method sets the callback, whose execute method is called when the trigger is activated.
 * @param callbackFunction The callback the user wants to set. This parameter must conform to the WLTriggerCallback protocol. 
 * When the trigger is activated, its execute method will be called and the current device context is passed as a parameter.
 * @return A reference to this object.
 */
- (WLGeoPositionChangeTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;

/**
 * This method sets the event to be transmitted to the server.
 * @param event The event the user wants to set.
 * @return A reference to this object.
 */
- (WLGeoPositionChangeTrigger*) setEvent : (NSMutableDictionary*) event ;

/**
 * This method determines whether the event is transmitted immediately, or whether it is transmitted according to the transmission policy.
 * If the value is true, the event is added to the transmission buffer, and the contents of the transmission buffer are flushed to the server. 
 * Otherwise the event is added only to the transmission buffer.
 * @param transmitImmediately A Boolean value that determines whether the event is transmitted immediately.
 * @return A reference to this object.
 */
- (WLGeoPositionChangeTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;

@end

