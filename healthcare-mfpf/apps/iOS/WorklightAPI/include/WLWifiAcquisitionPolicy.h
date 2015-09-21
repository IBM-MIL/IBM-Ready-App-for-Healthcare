/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiAcquisitionPolicy_H_
#import <Foundation/Foundation.h>

/**
* @ingroup geo
* Controls how WiFi locations will be acquired.
* <p>
* This class, like most classes used for configuring location services, returns
* a reference to this object from its setters, to enable chaining calls. 
*/
@interface WLWifiAcquisitionPolicy : NSObject  <NSCopying> {
	@private
	int signalStrengthThreshold;
	int interval;
	NSMutableArray* accessPointFilters;
}

/**
 * This method initializes the WiFi acquisition policy setting.
 */
- (id) init  ;
/**
	 * @return the signal strength threshold as a percentage.
	 * The default value is 15.
	 * @see #setSignalStrengthThreshold(int) 
	 */
- (int) getSignalStrengthThreshold  ;
/**
	 * @param signalStrengthThreshold specifies the signal strength threshold as a percentage. 
	 * Access points whose signal is weaker than this threshold are not reported in the list of visible access points. 
	 * However, the connected access point is still visible, even when its signal strength is below this threshold.
	 * The default value is 15.
	 * @return A reference to this object.
	 */
- (WLWifiAcquisitionPolicy*) setSignalStrengthThreshold : (int) signalStrengthThreshold ;
/**
	 * @param interval A polling interval, specified in milliseconds. WiFi polling is performed each interval.
	 * The default value is 10000 (10 seconds).
	 * @return A reference to this object.
	 */
- (WLWifiAcquisitionPolicy*) setInterval : (int) interval ;
/**
	 * @param accessPointFilters Only WiFi access points which match one of the access point filters will be visible. If the connected
	 * access point does not match any of the filters, it too will not be visible when using on-going acquisition (see
	 * {@link WLDevice#startAcquisition(com.worklight.location.api.WLLocationServicesConfiguration)}).
	 * If <code>null</code> will be treated as an empty list.
	 * @return A reference to this object.
	 */
- (WLWifiAcquisitionPolicy*) setAccessPointFilters : (NSMutableArray*) accessPointFilters ;
/**
	 * @return The access point filters; only Only WiFi access points which match at least one of these filters will be visible.
	 */
- (NSMutableArray*) getAccessPointFilters  ;
/**
	 * @return The polling interval, specified in milliseconds. WiFi polling is performed each interval.
      * The default value is 10000 (10 seconds).
	 */
- (int) getInterval  ;
- (WLWifiAcquisitionPolicy*) clone  ;
/*
	 * (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
- (int) hash  ;
/*
	 * (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
- (BOOL) isEqual : (NSObject*) obj ;

@end

