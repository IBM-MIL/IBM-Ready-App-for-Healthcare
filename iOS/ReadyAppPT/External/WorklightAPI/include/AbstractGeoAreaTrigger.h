/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractGeoAreaTrigger_H_
#import "WLConfidenceLevel.h"
#import "WLGeoTrigger.h"
@protocol WLArea;

/**
 * Defines parameter for Geo-WLTriggersConfiguration with area considerations
 */
@interface AbstractGeoAreaTrigger : WLGeoTrigger {
	@private
	id<WLArea> area;
	double bufferZoneWidth;
	WLConfidenceLevel confidenceLevel;
}


- (id) init  ;
/**
     * @return The trigger's area.
     */
- (id<WLArea>) getArea  ;
/**
     * @return The trigger's buffer zone width. The value indicates in meters how much to change the area.
     * It can have either a positive or negative value. If it has a positive value, the area becomes bigger.
     * If it has a negative value, the area becomes smaller. All geofence triggers operate on this new area.
     * The default value is 0, which leaves the area unchanged.
     */
- (double) getBufferZoneWidth  ;
/**
     * @param area the area for which the trigger will activate.
     * @return A reference to this object.
     */
- (AbstractGeoAreaTrigger*) setArea : (id<WLArea>) area ;
/**
     * @param bufferZoneWidth the bufferZoneWidth to set. Its value indicates in meters how much to change the area.
     * It can have either a positive or negative value. If it has a positive value, the area becomes bigger.
     * If it has a negative value, the area becomes smaller. All geofence triggers operate on this new area.
     * The default value is 0, which leaves the area unchanged.
     * @return A reference to this object.
     */
- (AbstractGeoAreaTrigger*) setBufferZoneWidth : (double) bufferZoneWidth ;
/**
     * @return the confidenceLevel. This indicates how a position's accuracy is to be taken into account.
     * @see WLConfidenceLevel
     */
- (WLConfidenceLevel) getConfidenceLevel  ;
/**
     * @param confidenceLevel the confidenceLevel to set. This indicates how a position's accuracy is to be taken into account.
     * @return A reference to this object.
     * @see WLConfidenceLevel
     */
- (AbstractGeoAreaTrigger*) setConfidenceLevel : (WLConfidenceLevel) confidenceLevel ;

@end

