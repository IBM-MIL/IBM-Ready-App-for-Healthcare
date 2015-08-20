/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

/**
 Contains JSONStore options that are used to open collections.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreOpenOptions : NSObject

/**
 The user name.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* username;

/**
 The password.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* password;

/**
 The secure random that is used for the Data Protection Key (DPK).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSString* secureRandom;

/**
 Determines if we log analytics data for JSONStore operations.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic) BOOL analytics;

@end
