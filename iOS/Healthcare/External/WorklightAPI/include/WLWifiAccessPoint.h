/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiAccessPoint_H_
#import <Foundation/Foundation.h>

/**
 * @ingroup geo
 * A WiFi access point
 */
@interface WLWifiAccessPoint : NSObject {
	@private
	NSString* ssid;
	NSString* mac;
}



/**
	 * @param SSID The access point's SSID
	 * @param MAC The access point's MAC address
	 */
- (id)initWithSSID:(NSString*)SSID MAC:(NSString*)MAC;
/**
	 * @return The access point's SSID
	 */
- (NSString*) getSSID  ;
/**
	 * @return MAC The access point's MAC address
	 */
- (NSString*) getMAC  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;
- (NSString*) description  ;

@end

