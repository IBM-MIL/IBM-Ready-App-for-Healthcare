/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiAcquisitionCallback_H_
#import <Foundation/Foundation.h>

/**
 * @ingroup geo
 * A callback for viewing the list of visible WiFi access points.
 */
@protocol WLWifiAcquisitionCallback <NSObject> 

/**
      * The method will be executed when the list of visible WiFi access points is acquired.
      * @param accessPoints the visible access points acquired.
      */
- (void) execute : (NSMutableArray*) accessPoints ;

@end

