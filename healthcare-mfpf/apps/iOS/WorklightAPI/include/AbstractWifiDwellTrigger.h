/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AbstractWifiDwellTrigger_H_
#import "AbstractWifiAreaTrigger.h"

/**
 * A trigger definition that deals with dwelling in an area of visible access points
 */
@interface AbstractWifiDwellTrigger : AbstractWifiAreaTrigger {
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
- (AbstractWifiDwellTrigger*) setDwellingTime : (long long) dwellingTime ;

@end

