/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoUtils_H_
#import <Foundation/Foundation.h>
#import "WLConfidenceLevel.h"
@class WLCircle;
@class WLCoordinate;
@class WLPolygon;
@protocol WLArea;

/**
 * @ingroup geo
 * Provides access to utility functions for Geo calculations.
 */
@interface WLGeoUtils : NSObject {
}


- (id) init  ;
/**
      * Calculates the distance between two coordinates.
      * <p>
      * The distance between two coordinates is calculated. The result is returned in meters, using a spherical model of the Earth.
      * </p>    
	 * @param coordinate1 The first coordinate.
	 * @param coordinate2 The second coordinate.
	 * @return The distance in meters between the two coordinates.
	 */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate1 toCoordinate:(WLCoordinate*)coordinate2;
/**
	 * Calculates the distance of the coordinate from the circle. Equivalent to calling
	 * {@link #getDistanceToCircle(WLCoordinate, WLCircle, double)}} with a <code>0</code> as the <code>bufferZoneWidth</code> parameter.
	 * 
	 * @param circle
	 * @param coordinate
	 * @return the distance in meters to the circle. The distance is positive for coordinates outside the circle and
	 *         negative for coordinates inside the circle.
	 */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate toCircle:(WLCircle*)circle;
/**
	 * Calculates the distance of the coordinate from the circle, taking into account the buffer zone.
	 * 
	 * @param coordinate
	 * @param circle
	 * @param bufferZoneWidth The buffer zone width is measured in meters. It enlarges the radius of the circle by this amount. Negative values make the circle smaller.
	 * @return The distance, in meters, to the circle, taking into account the buffer zone. The distance is positive for coordinates outside the circle, and negative for coordinates within the circle.
	 */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate toCircle:(WLCircle*)circle bufferZoneWidth:(double)bufferZoneWidth;
/**
	 * Returns a boolean value based on whether a coordinate lies within a circle.
	 * Equivalent to calling {@link #isInsideCircle(WLCoordinate, WLCircle, double, WLConfidenceLevel)}
	 * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
	 * 
	 * @param coordinate
	 * @param circle
	 * @return The value <code>true</code> is returned if the coordinate is within the circle.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insideCircle:(WLCircle*)circle;
/**
	 * Returns a boolean value based on whether a coordinate lies within a circle, taking into account the buffer zone and confidence level.
	 * 
	 * @param coordinate
	 * @param circle
      * @param bufferZoneWidth The buffer zone width is measured in meters. It enlarges the radius of the circle by this amount. Negative values make the circle smaller.
	 * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
	 * @return The value <code>true</code> is returned if the coordinate lies inside the circle, at the given level of confidence. The dimensions of the circle used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insideCircle:(WLCircle*)circle bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
      * Returns a boolean value based on whether a coordinate lies outside a circle.
      * Equivalent to calling {@link #isOutsideCircle(WLCoordinate, WLCircle, double, WLConfidenceLevel)}
      * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
      * 
      * @param coordinate
      * @param circle
      * @return <code>true</code> if the coordinate is outside the circle.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsideCircle:(WLCircle*)circle;
/**
      * Returns a boolean value based on whether a coordinate lies outside a circle, taking into account the buffer zone and confidence level.
      * 
      * @param coordinate
      * @param circle
      * @param bufferZoneWidth The buffer zone width is measured in meters. It enlarges the radius of the circle by this amount. Negative values make the circle smaller.
      * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
      * @return The value <code>true</code> is returned if the coordinate lies outside the circle, at the given level of confidence. The dimensions of the circle used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsideCircle:(WLCircle*)circle bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
	 * Calculates the distance of a coordinate from a polygon. Equivalent to calling
      * {@link #getDistanceToPolygon(WLCoordinate, WLPolygon, double)} with a <code>0</code> as the <code>bufferZoneWidth</code> parameter.
	 * 
	 * @param coordinate
	 * @param polygon
	 * @return The distance, in meters, to the polygon. The distance is positive for coordinates outside the polygon, and negative for coordinates within the polygon.
	 */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate toPolygon:(WLPolygon*)polygon;
/**
	 * Calculates the distance of the coordinate from the circle, taking into account the buffer zone.
	 * 
	 * @param coordinate
	 * @param polygon
	 * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the polygon in all directions by this amount. Negative values decrease the polygon's size.
	 * @return The distance, in meters, to the polygon, taking into account the buffer zone. The distance is positive for coordinates outside the polygon, and negative for coordinates within the polygon.
	 */
+ (double) getDistanceToPolygon : (WLCoordinate*) coordinate : (WLPolygon*) polygon : (double) bufferZoneWidth ;
/**
      * Returns a boolean value based on whether a coordinate lies within a polygon.
      * Equivalent to calling {@link #isInsidePolygon(WLCoordinate, WLPolygon, double, WLConfidenceLevel)}
      * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
      * 
      * @param coordinate
      * @param polygon
      * @return The value <code>true</code> is returned if the coordinate is within the polygon.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insidePolygon:(WLPolygon*)polygon;
/**
      * Returns a boolean value based on whether a coordinate lies within a polygon, taking into account the buffer zone and confidence level.
      * 
      * @param coordinate
      * @param polygon
      * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the polygon in all directions by this amount. Negative values decrease the polygon's size.
      * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
      * @return The value <code>true</code> is returned if the coordinate lies inside the polygon, at the given level of confidence. The dimensions of the polygon used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insidePolygon:(WLPolygon*)polygon bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
      * Returns a boolean value based on whether a coordinate lies outside a polygon, taking into account the buffer zone and confidence level.
      * 
      * @param coordinate
      * @param polygon
      * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the polygon in all directions by this amount. Negative values decrease the polygon's size.
      * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
      * @return The value <code>true</code> is returned if the coordinate lies outside the polygon, at the given level of confidence. The dimensions of the polygon used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsidePolygon:(WLPolygon*)polygon bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
      * Returns a boolean value based on whether a coordinate lies outside a polygon.
      * Equivalent to calling {@link #isOutsidePolygon(WLCoordinate, WLPolygon, double, WLConfidenceLevel)}
      * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
      * 
      * @param coordinate
      * @param polygon
      * @return <code>true</code> if the coordinate is outside the polygon.
      */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsidePolygon:(WLPolygon*)polygon;
/**
	 * Checks if the location is within the area taking into account the buffer zone and confidence level.
	 * 
	 * @param coordinate
	 * @param area
	 * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the area in all directions by this amount. Negative values decrease the area's size.
      * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
      * @return The value <code>true</code> is returned if the coordinate lies inside the area, at the given level of confidence. The dimensions of the area used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insideArea:(id<WLArea>)area bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
      * Returns a boolean value based on whether a coordinate lies within an area.
      * Equivalent to calling {@link #isInsideArea(WLCoordinate, WLArea, double, WLConfidenceLevel)}
      * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
	 * 
	 * @param coordinate
	 * @param area
      * @return The value <code>true</code> is returned if the coordinate lies inside the area, at the given level of confidence. The dimensions of the area used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate insideArea:(id<WLArea>)area;
/**
      * Returns a boolean value based on whether a coordinate lies outside an area, taking into account the buffer zone and confidence level.
	 * 
	 * @param coordinate
	 * @param area
      * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the area in all directions by this amount. Negative values decrease the area's size.
      * @param confidenceLevel The level of confidence indicates how accuracy is taken into account.
      * @return The value <code>true</code> is returned if the coordinate lies outside the area, at the given level of confidence. The dimensions of the area used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsideArea:(id<WLArea>)area bufferZoneWidth:(double)bufferZoneWidth confidenceLevel:(WLConfidenceLevel)confidenceLevel;
/**
      * Returns a boolean value based on whether a coordinate lies outside an area.
      * Equivalent to calling {@link #isOutsideArea(WLCoordinate, WLArea)}
      * with a <code>bufferZoneWidth</code> of <code>0</code> and a <code>confidenceLevel</code> of {@link WLConfidenceLevel#LOW}}.
	 * 
	 * @param coordinate
	 * @param area
      * @return The value <code>true</code> is returned if the coordinate lies outside the area, at the given level of confidence. The dimensions of the area used in this check incorporate any changes specified for the <b><code>bufferZoneWidth</code></b> parameter.
	 */
+ (BOOL)isCoordinate:(WLCoordinate*)coordinate outsideArea:(id<WLArea>)area;
/**
      * Calculates the distance of the coordinate from the area. Equivalent to calling
      * {@link #getDistanceToArea(WLCoordinate, WLArea, double)} with a <code>0</code> as the <code>bufferZoneWidth</code> parameter.
	 * 
	 * @param coordinate
	 * @param area
      * @return the distance in meters to the area. The distance is positive for coordinates outside the area and
      *         negative for coordinates inside the area.
	 */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate toArea:(id<WLArea>)area;
/**
      * Calculates the distance of the coordinate from the area, taking into account the buffer zone.
      * 
      * @param coordinate
      * @param area
      * @param bufferZoneWidth The buffer zone width is measured in meters. It increases the size of the area in all directions by this amount. Negative values decrease the area's size.
      * @return The distance, in meters, to the polygon, taking into account the buffer zone. The distance is positive for coordinates outside the area, and negative for coordinates within the area.
      */
+ (double)getDistanceFromCoordinate:(WLCoordinate*)coordinate toArea:(id<WLArea>)area bufferZoneWidth:(double)bufferZoneWidth;

@end

