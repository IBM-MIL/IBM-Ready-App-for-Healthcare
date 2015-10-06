/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractWifiAreaTrigger_H_
#import "WLConfidenceLevel.h"
#import "WLWifiTrigger.h"
@class WLWifiAcquisitionPolicy;

/**
 * A trigger definition handling wifi areas (a list of {@link WLWifiAccessPointFilter}).
 */
@interface AbstractWifiAreaTrigger : WLWifiTrigger {
	@private
	NSMutableArray* areaAccessPoints;
	BOOL otherAccessPointsAllowed;
	WLConfidenceLevel confidenceLevel;
}


- (id) init  ;
- (BOOL) validate : (WLWifiAcquisitionPolicy*) policy ;
/**
	 * @return the filters which specify which access points are considered by the trigger.
	 */
- (NSMutableArray*) getAreaAccessPoints  ;
/**
	 * @return the confidence level used for determining WiFi access point visibility.
	 * The default is {@link WLConfidenceLevel#LOW}.	 
	 */
- (WLConfidenceLevel) getConfidenceLevel  ;
/**
	 * @return whether only the access points specified for areaAccessPoints should be visible or not.
	 * The default value is false.
	 * @see #setOtherAccessPointsAllowed(boolean)
	 */
- (BOOL) areOtherAccessPointsAllowed  ;
/**
	 * @param areaAccessPoints Defines which access points are considered by the trigger. Wildcards
	 * are not allowed.
	 * @return A reference to this object.
	 */
- (AbstractWifiAreaTrigger*) setAreaAccessPoints : (NSMutableArray*) areaAccessPoints ;
/**
	 * @param otherAccessPointsAllowed indicates whether only the access points specified for areaAccessPoints should be visible,
	 * or whether other access points might be visible as well, where visibility is determined according to the WiFi acquisition policy.
	 * If the value is true, the trigger can be activated even when other access points are visible.
	 * If the value is false, this trigger is not activated when other access points are visible. The default value is false.
	 * @return A reference to this object.
	 */
- (AbstractWifiAreaTrigger*) setOtherAccessPointsAllowed : (BOOL) otherAccessPointsAllowed ;
/**
	 * Only access points whose signal strength meets the confidence level are considered visible.
	 * @param confidenceLevel specifies the minimum signal strength necessary for an access point.
	 * The default is {@link WLConfidenceLevel#LOW}.
	 * @return A reference to this object.
	 * @see WLConfidenceLevel
	 */
- (AbstractWifiAreaTrigger*) setConfidenceLevel : (WLConfidenceLevel) confidenceLevel ;

@end

