/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLLocationServicesConfiguration_H_
#import <Foundation/Foundation.h>
@class WLAcquisitionPolicy;
@class WLTriggersConfiguration;

/**
 * @ingroup geo
 * The configuration for on-going acquisition, including the
 * acquisition policy, triggers, and failure callbacks for handling acquisition errors.
 * <p>
 * This class, like most classes used for configuring location services, returns
 * a reference to this object from its setters, to enable chaining calls. 
 * 
 * @see WLDevice#startAcquisition(WLLocationServicesConfiguration)
 */
@interface WLLocationServicesConfiguration : NSObject  <NSCopying> {
	@private
	WLAcquisitionPolicy* policy;
	WLTriggersConfiguration* triggers;
	NSMutableArray* failureCallbacks;
}

/**
 * This method initializes the configuration.
 */
- (id) init  ;

/**
 * @return The failure callbacks. During on-going acquisition, the failure callbacks will be called when errors occur.
 */
- (NSMutableArray*) getFailureCallbacks  ;
/**
	 * @param failureCallbacks During on-going acquisition, the failure callbacks will be called when errors occur.
	 * @return A reference to this object.
	 */
- (WLLocationServicesConfiguration*) setFailureCallbacks : (NSMutableArray*) failureCallbacks ;
/**
	 * @return The acquisition policy
	 */
- (WLAcquisitionPolicy*) getPolicy  ;
/**
	 * @param policy the acquisition policy to set.
	 * @return A reference to this object.
	 * @see WLDevice#startAcquisition(WLLocationServicesConfiguration)
	 */
- (WLLocationServicesConfiguration*) setPolicy : (WLAcquisitionPolicy*) policy ;
/**
	 * @return The trigger configurations
	 */
- (WLTriggersConfiguration*) getTriggers  ;
/**
	 * @param triggers the triggers to be evaluated during ongoing acquisition.
	 * @return A reference to this object.
	 * @see WLDevice#startAcquisition(WLLocationServicesConfiguration)
	 */
- (WLLocationServicesConfiguration*) setTriggers : (WLTriggersConfiguration*) triggers ;
- (WLLocationServicesConfiguration*) clone  ;
- (int) hash  ;
- (BOOL) isEqual : (NSObject*) obj ;

@end

