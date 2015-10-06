/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLWifiTrigger_H_
#import "AbstractTrigger.h"
@class WLWifiAcquisitionPolicy;

/**
 * @ingroup geo
 * An abstract base class for WiFi triggers.
 */
@interface WLWifiTrigger : AbstractTrigger {
}


- (id) init  ;
/**
	 * Checks if the trigger can ever be evaluated to true under a policy
	 * 
	 * @param policy The policy to check
	 * @return <code>true</code> iff there is a {@link WifiInternalLocationn} that could be matched by the policy and will be
	 *         evaluated to true when calling {@link WifiTriggerEvaluator#evaluate(WifiInternalLocation)}.
	 * @exclude
	 */
- (BOOL) validate : (WLWifiAcquisitionPolicy*) policy ;

@end

