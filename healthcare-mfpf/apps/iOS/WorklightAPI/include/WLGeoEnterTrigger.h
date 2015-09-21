/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoEnterTrigger_H_
#import "AbstractGeoAreaTrigger.h"
#import "WLConfidenceLevel.h"
@protocol WLArea;
@protocol WLTriggerCallback;

/**
 * @ingroup geo
 * A trigger definition that is activated when a device enters an area. To activate the trigger, the device must first have been outside the area, and then enter the area at the given confidence level.
 * <p>
 * The setters of this class return a reference to this object so as to enable chaining calls.
 */
@interface WLGeoEnterTrigger : AbstractGeoAreaTrigger {
}

/**
 * This method initializes the trigger definition.
 *
 * @param None.
 **/
- (id) init  ;
- (WLGeoEnterTrigger*) clone  ;

/**
 * This method sets the buffer zone width, in meters. The buffer zone width value determines how much the area is changed. If the value is positive, the area becomes bigger. If the value is negative, the area becomes smaller. All geofence triggers operate on the new area.
 * The default value is 0, which leaves the area unchanged.
 *
 * @param bufferZoneWidth  The buffer zone width the user wants to set.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setBufferZoneWidth : (double) bufferZoneWidth ;

/**
 * This method sets the area for which the trigger will activate.
 *
 * @param area The area the user wants to set. This value is passed as a parameter to the execute method of this object, which should be an instance of <code>WLCircle</code> or <code>WLPolygon</code>.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setArea : (id<WLArea>) area ;

/**
 * This method sets the callback, whose execute method is called when the trigger is activated.
 *
 * @param callback The callback the user wants to set. This parameter must conform to the <code>WLTriggerCallback</code> protocol. When the trigger is activated, its execute method will be called and the current device context is passed as a parameter.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setCallback : (id<WLTriggerCallback>) callbackFunction ;

/**
 * This method sets the confidence level. The value indicates how the accuracy of a position is taken into account.
 *
 * @param confidenceLevel The confidence level the user wants to set.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setConfidenceLevel : (WLConfidenceLevel) confidenceLevel ;

/**
 * This method sets the event that is transmitted to the server.
 *
 * @param event The event the user wants to set.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setEvent : (NSMutableDictionary*) event ;

/**
 * This method determines whether the event is transmitted immediately, or whether it is transmitted according to the transmission policy. If the value is true, the event is added to the transmission buffer, and the contents of the transmission buffer are flushed to the server. Otherwise the event is added only to the transmission buffer.
 *
 * @param transmitImmediately A Boolean value that determines whether the event is transmitted immediately.
 * @return A reference to this object.
 **/
- (WLGeoEnterTrigger*) setTransmitImmediately : (BOOL) transmitImmediately ;

@end

