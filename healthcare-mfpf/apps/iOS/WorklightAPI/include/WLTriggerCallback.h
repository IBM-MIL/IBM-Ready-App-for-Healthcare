/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLTriggerCallback_H_
#import <Foundation/Foundation.h>
@protocol WLDeviceContext;

/**
 * @ingroup geo
 * A callback for when a trigger is activated.
 */
@protocol WLTriggerCallback <NSObject> 

/**
	 * The method will be executed when the trigger is activated.
	 * @param deviceContext The device context at the time when the trigger is activated.
	 */
- (void) execute : (id<WLDeviceContext>) deviceContext ;

@end

