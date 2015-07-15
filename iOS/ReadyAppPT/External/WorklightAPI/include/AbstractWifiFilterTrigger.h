/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractWifiFilterTrigger_H_
#import "WLWifiTrigger.h"
@class WLWifiAccessPointFilter;
@class WLWifiAcquisitionPolicy;

/**
 * Parent class of connected and disconnected triggers
 */
@interface AbstractWifiFilterTrigger : WLWifiTrigger {
	@private
	WLWifiAccessPointFilter* connectedAccessPoint;
}


- (id) init  ;
+ (BOOL) doesPolicyIntersectWithFilter : (WLWifiAcquisitionPolicy*) policy : (WLWifiAccessPointFilter*) filter ;
/**
	 * @exclude
	 */
- (BOOL) validate : (WLWifiAcquisitionPolicy*) policy ;
/**
	 * @return the filter which the connected Wifi access point must match in order for the trigger to activate.
	 */
- (WLWifiAccessPointFilter*) getConnectedAccessPoint  ;
/**
	 * @param connectedAccessPoint the filter which the connected Wifi access point must match in order for the trigger
	 * to activate.
	 * @return A reference to this object.
	 */
- (AbstractWifiFilterTrigger*) setConnectedAccessPoint : (WLWifiAccessPointFilter*) connectedAccessPoint ;

@end

