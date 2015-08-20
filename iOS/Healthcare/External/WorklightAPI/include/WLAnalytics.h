/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

/**
 Contains WLAnalytics methods that manage analytics logs.
 */
@interface WLAnalytics : NSObject

@property (strong, nonatomic) NSMutableDictionary *config;

+ (WLAnalytics *) sharedInstance;

/**
 This method enables capturing of analytics log data
 @since IBM Worklight V6.2.0
 */
- (void) enable;

/**
 This method disables capturing of analytics log data
 @since IBM Worklight V6.2.0
 */
- (void) disable;

/**
 This method sends the log file when the log buffer exists and is not empty.
 @since IBM Worklight V6.2.0
 */
- (void) send;

/**
 This method logs analytics data
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since Worklight V6.2.0
 */
- (void) log:(NSString*)message withMetadata:(NSDictionary*)metadata;

@end
