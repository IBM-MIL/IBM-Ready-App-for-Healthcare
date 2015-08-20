/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

/**
 Contains JSONStore options for the add API.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreAddOptions : NSObject

/**
 Dictionary of additional search fields. Example: {@"name" : @"carlos"}.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSDictionary* additionalSearchFields;

@end
