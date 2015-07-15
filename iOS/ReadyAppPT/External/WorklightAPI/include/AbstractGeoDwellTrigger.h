/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractGeoDwellTrigger_H_
#import "AbstractGeoAreaTrigger.h"

/**
 * A trigger definition for dwelling a period of time inside or outside an area
 */
@interface AbstractGeoDwellTrigger : AbstractGeoAreaTrigger {
	@private
	long long dwellingTime;
}


- (id) init  ;
/**
	 * @return The minimum time the device needs to be inside or outside
	 * the area before the trigger will be activated.
	 */
- (long long) getDwellingTime  ;
/**
	 * @param dwellingTime a time defined in milliseconds. It defines how long the device must be inside, or outside,
	 * the area before the trigger is activated.
	 */
- (AbstractGeoDwellTrigger*) setDwellingTime : (long long) dwellingTime ;

@end

