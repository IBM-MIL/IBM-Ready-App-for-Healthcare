/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoPosition_H_
#import "AbstractPosition.h"
@class WLCoordinate;

/**
 * @ingroup geo
 * An acquisition of a {@link WLCoordinate}.
 */
@interface WLGeoPosition : AbstractPosition {
	@private
	WLCoordinate* coordinate;
}



/**
	 * Creates a new WLGeoPosition with acquisition time
	 * 
	 * @param coordinate The coordinate acquired
	 * @param acquisitionTime The time of the acquisition
	 * @exclude
	 */
- (id)initWithCoordinate:(WLCoordinate*)coordinate acquisitionTime:(long long)acquisitionTime;
/**
 * This method initializes the acquired coordinate.
 */
- (id) init  ;
- (NSString*) description  ;
/**
	 * @return The acquired coordinate
	 */
- (WLCoordinate*) getCoordinate  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

