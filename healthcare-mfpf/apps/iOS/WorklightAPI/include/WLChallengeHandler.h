/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLChallengeHandler.h
//  WorklightStaticLibProject
//
//  Created by Ishai Borovoy on 9/13/12.
//

#import "BaseChallengeHandler.h"
#import "WLFailResponse.h"


/**
 * @ingroup main
 * You use this base class to create an IBM MobileFirst Platform Challenge Handler.
 * You must extend this class to implement your own version of an IBM MobileFirst Platform Challenge Handler, for example RemoteDisableChallengeHandler.
 */
@interface WLChallengeHandler : BaseChallengeHandler
    /**
     * Send the answer back to the request.
     */
    -(void) submitChallengeAnswer: (NSDictionary *)answer;

	/**
    * This method is called when the IBM MobileFirst Platform Server reports an authentication success.
    */
    -(void) handleSuccess: (NSDictionary *)success;
    
    /**
    *  This method is called when the IBM MobileFirst Platform Server reports an authentication failure.
    */
    -(void) handleFailure: (NSDictionary *)failure;
    
    /**
    * This method is called when the IBM MobileFirst Platform Server returns a challenge for the realm.
    */
    -(void) handleChallenge: (NSDictionary *)challenge;
@end
