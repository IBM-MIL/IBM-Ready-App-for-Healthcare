/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiConnectedCallback_H_
#import <Foundation/Foundation.h>
@class WLWifiAccessPoint;

/**
 * @ingroup geo
 * A callback for getting the connected WiFi access point
 */
@protocol WLWifiConnectedCallback <NSObject> 

/**
      * The method will be executed when the connected Wifi access point is acquired
      * @param connectedAccessPoint the connected access point (including SSID and MAC address).
      * @param signalStrength the connected signal strength, as a percentage.
      */
- (void) execute : (WLWifiAccessPoint*) connectedAccessPoint : (NSNumber*) signalStrength ;

@end

