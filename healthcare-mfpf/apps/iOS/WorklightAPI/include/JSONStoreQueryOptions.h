/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

/**
 Contains JSONStore query options.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreQueryOptions : NSObject

/**
 Private. Flag to turn a find into a count.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic) BOOL _count;

/**
 Private. NSArray with sort criteria (e.g. [{name: @"ASC"}]).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSMutableArray* _sort;

/**
 Private. NSArray with filter criteria (e.g. [@"name", @"age"]).
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSMutableArray* _filter;

/**
 Determines the maximum number of results to return.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSNumber* limit;

/**
 Determines the maximum number of documents to skip from the result.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic,strong) NSNumber* offset;

/**
 Sorts by search field ascending.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) sortBySearchFieldAscending:(NSString*) searchField;

/**
 Sorts by search field descending.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) sortBySearchFieldDescending:(NSString*) searchField;

/**
 Filter by search field.
 @param searchField Search field
 @since IBM Worklight V6.2.0
 */
-(void) filterSearchField:(NSString*) searchField;

/**
 String representation of the object.
 @since IBM Worklight V6.2.0
 */
-(NSString*) description;

@end
