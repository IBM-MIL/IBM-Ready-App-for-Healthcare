/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoExitTrigger_H_
#import "AbstractGeoAreaTrigger.h"
#import "WLConfidenceLevel.h"
@protocol WLArea;
@protocol WLTriggerCallback;

/**
 * @ingroup geo
 * A trigger definition that is activated when a device leaves an area.  The device must first have been inside the area and
 * then exited the area at the given confidence level in order for the trigger to activate. In order to re-activate
 * the device must first enter the area.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls.
 */
@interface WLGeoExitTrigger : AbstractGeoAreaTrigger {
}

/**
 * This method initializes the trigger definition.
 */
- (id) init  ;

- (WLGeoExitTrigger*) clone  ;
/**
 * @param bufferZoneWidth The buffer zone width the user wants to set.
 * This method sets the buffer zone width, in meters. The buffer zone width value determines how much the area is changed.
 * If the value is positive, the area becomes bigger. If the value is negative, the area becomes smaller. All geofence triggers operate on the new area.
 * The default value is 0, which leaves the area unchanged.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setBufferZoneWidth : (double) bufferZoneWidth ;
/**
 * @param area The area the user wants to set.
 * This method sets the area for which the trigger will activate.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setArea : (id<WLArea>) area ;
/**
 * @param callbackFunction The callback the user wants to set. This parameter must conform to the WLTriggerCallback protocol. When the trigger is activated, its execute method will be called and the current device context is passed as a parameter.
 * This method sets the callback, whose execute method is called when the trigger is activated.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;
/**
 * @param confidenceLevel The confidence level the user wants to set.
 * This method sets the confidence level. The value indicates how the accuracy of a position is taken into account.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setConfidenceLevel : (WLConfidenceLevel) confidenceLevel ;
/**
 * @param event The event the user wants to set.
 * This method sets the event to be transmitted to the server.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setEvent : (NSMutableDictionary*) event ;
/**
 * @param transmitImmediately A Boolean value that determines whether the event is transmitted immediately
 * This method determines whether the event is transmitted immediately, or whether it is transmitted according to the transmission policy. 
 * If the value is true, the event is added to the transmission buffer, and the contents of the transmission buffer are flushed to the server. 
 * Otherwise the event is added only to the transmission buffer.
 * @return A reference to this object.
 */
- (WLGeoExitTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;

@end

