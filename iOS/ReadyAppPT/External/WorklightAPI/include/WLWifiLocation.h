/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiLocation_H_
#import "AbstractPosition.h"
@class WLWifiAccessPoint;

/**
 * @ingroup geo
 * A wifi location as determined by the visible access points and connected access point, filtered by a policy.
 */
@interface WLWifiLocation : AbstractPosition {
	@private
	NSMutableArray* accessPoints;
	WLWifiAccessPoint* connectedAccessPoint;
	NSNumber* connectedSignalStrength;
}



/**
	 * Creates a new {@link WLWifiLocation}
	 * 
	 * @param accessPoints The access points acquired, which have passed the filter of the policy
	 * @param acquisitionTime The time of the acquisition
	 * @exclude
	 */
- (id)initWithAccessPoints:(NSMutableArray*)accessPoints connectedAccessPoint:(WLWifiAccessPoint*)connectedAccessPoint connectedSignalStrength:(NSNumber*)connectedSignalStrength acquisitionTime:(long long)acquisitionTime;

/**
 * This method initializes the WiFi location.
 */
- (id) init  ;
/**
	 * @return Filtered access points (a subset of all visible access points filtered according to policy).
	 */
- (NSMutableArray*) getAccessPoints  ;
/**
	 * @return Information about the connected access point if it is passes the policy filters.
	 * If it doesn't pass the policy filters, then returns <code>null</code>.
	 */
- (WLWifiAccessPoint*) getConnectedAccessPoint  ;
/**
	 * @return The signal strength for the connected access point as a percentage. Returns <code>null</code> if
	 *         {@link #getConnectedAccessPoint()} returns <code>null</code>.
	 */
- (NSNumber*) getConnectedSignalStrength  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;
- (NSString*) description  ;

@end

