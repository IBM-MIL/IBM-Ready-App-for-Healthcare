/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoCallback_H_
#import <Foundation/Foundation.h>
#import "AcquisitionCallback.h"
@class WLGeoPosition;

/**
 * @ingroup geo
 * This protocol is used to define callbacks for when a geographical position is acquired.
 */
@protocol WLGeoCallback <AcquisitionCallback>

/**
 * This method is executed when a geographical position is acquired.
 *
 * @param pos The acquired geographical position.
 */
- (void) execute : (WLGeoPosition*) pos ;

@end
