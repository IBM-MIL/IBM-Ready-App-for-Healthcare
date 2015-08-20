/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLAcquisitionFailureCallbacksConfiguration_H_
#import <Foundation/Foundation.h>
@protocol WLGeoFailureCallback;
@protocol WLWifiFailureCallback;

/**
 * @ingroup geo
 * Configuration of the callbacks to be called when there is an acquisition failure.
 * <p>
 * This class defines the configuration of the callbacks that are called when there is an acquisition failure.
 * The setters of this class return a reference to this object so as to enable chaining calls.
 */
@interface WLAcquisitionFailureCallbacksConfiguration : NSObject  <NSCopying> {
	@private
	id<WLGeoFailureCallback> geoFailureCallback;
	id<WLWifiFailureCallback> wifiFailureCallback;
}


- (id) init  ;
/**
 * This method returns the WiFi failure callback. The default value is null.
 *
 * @param None.
 * @return The wifi failure callback. The default is <code>null</code>.
 **/
- (id<WLWifiFailureCallback>) getWifiFailureCallback  ;


/**
 * This method returns the geolocation failure callback. The default value is null.
 *
 * @param None.
 * @return The geo failure callback. The default is <code>null</code>.
 **/
- (id<WLGeoFailureCallback>) getGeoFailureCallback  ;

/**
* Sets the WiFi failure callback.
*
* @param wifiFailureCallbacks A reference to an object that conforms to the WLWifiFailureCallback protocol. 
* @return A reference to this object.
**/
- (WLAcquisitionFailureCallbacksConfiguration*) setWifiFailureCallback : (id<WLWifiFailureCallback>) wifiFailureCallbacks ;

/**
 * Sets the geolocation failure callback.
 *
 * @param geoFailureCallbacks A reference to an object that conforms to the WLGeoFailureCallback protocol.
 * @return A reference to this object.
 **/
- (WLAcquisitionFailureCallbacksConfiguration*) setGeoFailureCallback : (id<WLGeoFailureCallback>) geoFailureCallbacks ;


- (WLAcquisitionFailureCallbacksConfiguration*) clone  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

