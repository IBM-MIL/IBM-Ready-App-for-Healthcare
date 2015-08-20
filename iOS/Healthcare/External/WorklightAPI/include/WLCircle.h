/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLCircle_H_
#import <Foundation/Foundation.h>
#import "WLArea.h"
@class WLCoordinate;
@protocol AreaVisitor;

/**
 * @ingroup geo
 * A circle, defined by its center point and a radius.
 * This class is immutable.
 */
@interface WLCircle : NSObject  <WLArea> {
	@private
/**
	 * The circle's radius in meters
	 */
	double radius;
/**
	 * The circle's center
	 */
	WLCoordinate* center;
}

/**
 * @short This method creates a new circle.
 *
 * @param center The circle's center
 * @param radius The circle's radius (in meters)
 **/
- (id)initWithCenter:(WLCoordinate*)center radius:(double)radius;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;
/**
	 * @exclude
	 */
- (NSObject*) accept : (id<AreaVisitor>) visitor ;

/**
 * This method returns the radius of the circle, in meters.
 *
 * @param None.
 * @return the circle's radius in meters.
 **/
- (double) getRadius  ;


/**
 * This method returns the center of the circle.
 *
 * @param None.
 * @return the center of the circle.
 **/
- (WLCoordinate*) getCenter  ;

@end

