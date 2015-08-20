/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiDwellOutsideTrigger_H_
#import "AbstractWifiDwellTrigger.h"
#import "WLConfidenceLevel.h"
@class AbstractWifiAreaTrigger;
@protocol WLTriggerCallback;

/**
 * @ingroup geo
 * A trigger definition for dwelling a period of time outside an area. In order to re-activate
 * the device must first enter the area. The area is defined by the visibility
 * of a set of given access points.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls.
 */
@interface WLWifiDwellOutsideTrigger : AbstractWifiDwellTrigger {
}

/**
 * This method initializes the trigger definition.
 */
- (id) init  ;
- (WLWifiDwellOutsideTrigger*) clone  ;
/**
 * This method defines which access points are considered by the trigger. Wildcards are not permitted.
 * @param areaFilters The access points the user wants to set for the WiFi location.
 * @return A reference to this object.
 */
- (WLWifiDwellOutsideTrigger*) setAreaAccessPoints : (NSMutableArray*) areaFilters ;
- (WLWifiDwellOutsideTrigger*) setOtherAccessPointsAllowed : (BOOL) otherAccessPointsAllowed ;

/**
 * This method sets the callback, whose execute method is called when the trigger is activated.
 * @param callbackFunction The callback the user wants to set. This parameter must conform to the WLTriggerCallback protocol. 
 * When the trigger is activated, its execute method will be called and the current device context is passed as a parameter.
 * @return A reference to this object.
 */
- (WLWifiDwellOutsideTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;

/**
 * This method sets the event to be transmitted to the server.
 * @param event The event the user wants to set.
 * @return A reference to this object.
 */
- (WLWifiDwellOutsideTrigger*) setEvent : (NSMutableDictionary*) event ;

/**
 * This method sets the dwelling time. The method defines how long the device must be inside the area before the trigger is activated.
 * @param dwellingTime The dwelling time in milliseconds.
 * @return A reference to this object.
 */
- (WLWifiDwellOutsideTrigger*) setDwellingTime : (long long) dwellingTime ;

/**
 * This method determines whether the event is transmitted immediately, or whether it is transmitted according to the transmission policy. 
 * If the value is true, the event is added to the transmission buffer, and the contents of the transmission buffer are flushed to the server. 
 * Otherwise the event is added only to the transmission buffer.
 * @param transmitImmediately A Boolean value that determines whether the event is transmitted immediately.
 * @return A reference to this object.
 */
- (WLWifiDwellOutsideTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;

/**
	 * Confidence levels are not supported for the Dwell Outside trigger.
	 * This method always throws an UnsupportedOperationException.
	 * @throws UnsupportedOperationException
	 */
- (AbstractWifiAreaTrigger*) setConfidenceLevel : (WLConfidenceLevel) confidenceLevel ;

@end

