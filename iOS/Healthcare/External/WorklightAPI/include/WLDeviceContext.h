/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLDeviceContext_H_
#import <Foundation/Foundation.h>
@class WLGeoPosition;
@class WLWifiLocation;

/**
 * @ingroup geo
 * This protocol provides information on position acquisitions.
 * <p>
 * The context for the device, comprising of the acquired data for each of the sensors.
 * The instance available through <code>WLClient.getInstance().getWLDevice().getWLDeviceContext()</code>
 * is updated as a result of ongoing acquisition.
 */
@protocol WLDeviceContext <NSObject> 

/**
 * This method returns the last geographical position acquired. If no position has been acquired, null is returned.
 *
 * @param none
 * @return the latest acquired Geo position. Returns <code>null</code> if none acquired.
 **/
- (WLGeoPosition*) getGeoPosition  ;

/**
 * This method returns the last WiFi location acquired. If no location has been acquired, null is returned.
 *
 * @param none
 * @return the latest acquired WiFi location. Returns <code>null</code> if none acquired.
 **/
- (WLWifiLocation*) getWifiLocation  ;

/**
 * This method returns a timestamp that matches the maximum timestamp of the geographical position or the WiFi location. If neither has a timestamp, <code>null</code> is returned.
 *
 * @param none
 * @return A timestamp which matches the maximum timestamp of the Geo position or Wifi location. If neither have a timestamp, then will be <code>null</code>.
 **/

- (NSNumber*) getLastModified  ;
/**
 * This method returns the timezone offset, in minutes, that should be added to the user’s local time to provide the UTC time.
 *
 * @param none
 * @return The timezone offset in minutes that should be added to the user's local time to arrive at UTC time.
 **/
- (NSNumber*) getTimezoneOffset  ;

/**
 * This method returns the data formatted as a JSON object. If there was no ongoing acquisition for any sensor when this object was created, null is returned.
 *
 * @param none
 * @return The data formatted as a JSON object. If there was no on-going acquisition for any sensor when this object was created, it will return <code>null</code>.
 **/
- (NSMutableDictionary*) getJSON  ;

/**
	 * Adds the JSON representation as returned by {@link #getJSON()} to an event.
	 * A typical use of this method would be when sending a dynamic event as a result of a trigger being activated (i.e., the event is constructed when the trigger is activated and not when the trigger was created). 
     * The WLDeviceContext instance received by {@link WLTriggerCallback#execute(WLDeviceContext)} would add its data to a dynamic event object which would then be passed to {@link WLClient#transmitEvent(JSONObject, boolean)}.
	 * If the JSON representation is <code>null</code>, then {@link JSONObject#NULL} is added.
	 * @param event the JSONObject to update
	 */
- (void) addToEvent : (NSMutableDictionary*) event ;

@end

