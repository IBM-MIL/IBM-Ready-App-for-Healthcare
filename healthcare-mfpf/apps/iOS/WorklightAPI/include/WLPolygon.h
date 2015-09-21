/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLPolygon_H_
#import <Foundation/Foundation.h>
#import "WLArea.h"
@class WLCoordinate;
@protocol AreaVisitor;

/**
 * @ingroup geo
 * A polygon is defined by a list of coordinates.
 * This class is immutable.
 */
@interface WLPolygon : NSObject  <WLArea> {
	@public
/**
	 * The number of coordinates in this polygon
	 */
	int length;
	@private
	NSMutableArray* coordinates;
}



/**
	 * @param coordinates The coordinates of the polygon
	 * @throws IllegalArgumentException if coordinates is null or empty
	 */
- (id) init : (NSMutableArray*) coordinates ;
/**
	 * @return A copy of the coordinates that make up this polygon
	 */
- (NSMutableArray*) getCoordinates  ;
- (NSString*) description  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;
/**
	 * @param idx The index of the coordinate to retrieve
	 * @return The coordinate with index <code>idx</code> in the list.
	 */
- (WLCoordinate*) get : (int) idx ;
/**
	 * @exclude
	 */
- (NSObject*) accept : (id<AreaVisitor>) visitor ;

@end

