/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLCoordinate_H_
#import <Foundation/Foundation.h>

/**
 * @ingroup geo
 * This class defines a coordinate on the globe.
 */
@interface WLCoordinate : NSObject {
	@private
	double latitude;
	double longitude;
	double accuracy;
	NSNumber* altitude;
	NSNumber* altitudeAccuracy;
	NSNumber* heading;
	NSNumber* speed;
}


/**
 * This method initializes the coordinate with the given values.
 *
 * @param latitude The coordinate's latitude value
 * @param longitude The coordinate's longitude value
 **/
- (id)initWithLatitude:(double)latitude longitude:(double)longitude;

/**
 * This method initializes the coordinate with the given values.
 *
 * @param latitude The coordinate's latitude value
 * @param longitude The coordinate's longitude value
 * @param accuracy The coordinate's accuracy
 **/
- (id)initWithLatitude:(double)latitude longitude:(double)longitude accuracy:(double)accuracy;
- (id)initWithLatitude:(double)latitude longitude:(double)longitude altitude:(NSNumber*)altitude accuracy:(double)accuracy altitudeAccuracy:(NSNumber*)altitudeAccuracy heading:(NSNumber*)heading speed:(NSNumber*)speed;
- (NSString*) description  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

/**
 * This method returns the latitude of the coordinate
 *
 * @param None
 * @return the coordinate's latitude.
 **/
- (double) getLatitude  ;

/**
 * This method returns the longitude of the coordinate
 *
 * @param None
 * @return the coordinate's longitude.
 **/
- (double) getLongitude  ;

/**
 * This method returns the accuracy of the coordinate, in meters.
 *
 * @param None
 * @return The coordinate's accuracy, in meters.
 **/
- (double) getAccuracy  ;

/**
 * This method returns the altitude of the coordinate, in meters, if available. If unavailable, <code>null</code> is returned.
 *
 * @param None
 * @return The coordinate's altitude, in meters.
 **/
- (NSNumber*) getAltitude  ;

/**
 * This method returns the altitude accuracy of the coordinate,, in meters, if available. If unavailable, <code>null</code> is returned.
 *
 * @param None
 * @return The coordinate's altitude accuracy, in meters.
 **/
- (NSNumber*) getAltitudeAccuracy  ;

/**
 * This method returns the heading of the coordinate, in degrees (0–360), if available. If unavailable, <code>null</code> is returned.
 *
 * @param None
 * @return The coordinate's heading, in degrees [0-360).
 **/
- (NSNumber*) getHeading  ;

/**
 * This method returns the speed of the coordinate, in meters per second, if available.If unavailable, <code>null</code> is returned.
 *
 * @param None
 * @return The coordinate's speed, in meters per second.
 **/
- (NSNumber*) getSpeed  ;

@end

