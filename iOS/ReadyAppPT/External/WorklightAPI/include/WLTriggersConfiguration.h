/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLTriggersConfiguration_H_
#import <Foundation/Foundation.h>

/**
 * @ingroup geo
 * A configuration object containing the triggers.
 * The policy should be set in an instance of {@link WLLocationServicesConfiguration} which 
 * is then passed to {@link WLDevice#startAcquisition(WLLocationServicesConfiguration)}
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls. 
 */
@interface WLTriggersConfiguration : NSObject  <NSCopying> {
	@private
	NSMutableDictionary* geoTriggers;
	NSMutableDictionary* wifiTriggers;
}



/**
	 * Creates a new instance with default (empty) triggers.
	 */
- (id) init  ;
/**
	 * Sets the Geo triggers. 
	 * 
	 * @param geoTriggers The new triggers to set. Each trigger needs a unique key in the map. If <code>null</code>, then an empty map will be set.
	 * @return A reference to this object.
	 */
- (WLTriggersConfiguration*) setGeoTriggers : (NSMutableDictionary*) geoTriggers ;
/**
	 * Sets the WiFi triggers.
	 * 
      * @param wifiTriggers The new triggers to set. Each trigger needs a unique key in the map. If <code>null</code>, then an empty map will be set.
	 * @return A reference to this object.
	 */
- (WLTriggersConfiguration*) setWifiTriggers : (NSMutableDictionary*) wifiTriggers ;
/**
	 * @return The Geo triggers
	 */
- (NSMutableDictionary*) getGeoTriggers  ;
/**
	 * @return The WiFi triggers
	 */
- (NSMutableDictionary*) getWifiTriggers  ;
- (WLTriggersConfiguration*) clone  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

