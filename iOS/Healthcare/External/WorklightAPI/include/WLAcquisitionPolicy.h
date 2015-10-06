/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLAcquisitionPolicy_H_
#import <Foundation/Foundation.h>
@class WLGeoAcquisitionPolicy;
@class WLWifiAcquisitionPolicy;

/**
 * @ingroup geo
 * The acquisition policy controls how Geo and WiFi locations will be acquired.
 *
 * The policy should be set in an instance of {@link WLLocationServicesConfiguration} which 
 * is then passed to {@link WLDevice#startAcquisition(WLLocationServicesConfiguration)}
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls. 
 */
@interface WLAcquisitionPolicy : NSObject  <NSCopying> {
	@private
	WLWifiAcquisitionPolicy* wifiPolicy;
	WLGeoAcquisitionPolicy* geoPolicy;
}



/**
	 * Creates a new policy with the default (<code>null</code>) policies.<br>
	 * This policy can be used to stop all on-going acquisition.
	 */
- (id) init  ;

/**
 * Sets the WiFi acquisition policy. When <code>null</code>, it can be used to stop WiFi acquisition.
 *
 * @param wifiPolicy the WiFi acquisition policy to set.
 * @return A reference to this object.
 **/
- (WLAcquisitionPolicy*) setWifiPolicy : (WLWifiAcquisitionPolicy*) wifiPolicy ;

/**
 * This method returns the WiFi acquisition policy.
 *
 * @param None.
 * @return The WiFi acquisition policy.
 **/
- (WLWifiAcquisitionPolicy*) getWifiPolicy  ;

/**
 * This method sets the geolocation acquisition policy. When <code>null</code>, it can be used to stop Geo acquisition.
 *
 * @param geoPolicy The geolocation acquisition policy to set.
 * @return A reference to this object.
 **/
- (WLAcquisitionPolicy*) setGeoPolicy : (WLGeoAcquisitionPolicy*) geoPolicy ;

/**
 * This method returns the geolocation acquisition policy.
 *
 * @param None.
 * @return The Geo acquisition policy.
 **/
- (WLGeoAcquisitionPolicy*) getGeoPolicy  ;

- (WLAcquisitionPolicy*) clone  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

