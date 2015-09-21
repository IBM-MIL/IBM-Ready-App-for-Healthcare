/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

/**
 Contains JSONStore query part operations.
 @since IBM Worklight V6.2.0
 */
@interface JSONStoreQueryPart : NSObject

/**
 Private. Special case when looking for _id values.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _ids;

/**
 Private. NSArray with less than criteria (e.g. [{age: 20}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _lessThan;

/**
 Private. NSArray with less than or equal to criteria (e.g. [{age: 20}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _lessOrEqualThan;

/**
 Private. NSArray with greater than criteria (e.g. [{age: 20}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _greaterThan;

/**
 Private. NSArray with greater than or equal to criteria (e.g. [{age: 20}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _greaterOrEqualThan;

/**
 Private. NSArray with like criteria (e.g. [{name: @"carlos"}]) that matches right and left of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _like;

/**
 Private. NSArray with not like criteria (e.g. [{name: @"carlos"}]) that matches right and left of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notLike;

/**
 Private. NSArray with like criteria (e.g. [{name: @"carlos"}]) that matches only right of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _rightLike;

/**
 Private. NSArray with not like criteria (e.g. [{name: @"carlos"}]) that matches only right of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notRightLike;

/**
 Private. NSArray with like criteria (e.g. [{name: @"carlos"}]) that matches only left of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _leftLike;

/**
 Private. NSArray with not like criteria (e.g. [{name: @"carlos"}]) that matches only left of the input.
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notLeftLike;

/**
 Private. NSArray with equal to criteria (e.g. [{name: @"carlos"}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _equal;

/**
 Private. NSArray with not equal to criteria (e.g. [{name: @"carlos"}]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notEqual;

/**
 Private. NSArray with in criteria (e.g. [ [@"carlos", @"dgonz", @"mike"] ]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _inside;

/**
 Private. NSArray with not in criteria (e.g. [ [@"carlos", @"dgonz", @"mike"] ]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notInside;

/**
 Private. NSArray with between criteria (e.g. [ [50,100] ]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _between;

/**
 Private. NSArray with not between criteria (e.g. [ [50,100] ]).
 @since IBM Worklight V6.2.0
 @private
 */
@property (nonatomic, retain) NSMutableArray* _notBetween;

/**
 Add a less than criteria.
 @param searchField Search field
 @param number Number
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
           lessThan:(NSNumber*) number;

/**
 Add a less than or equal to criteria.
 @param searchField Search field
 @param number Number
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
    lessOrEqualThan:(NSNumber*) number;

/**
 Add a greater than criteria.
 @param searchField Search field
 @param number Number
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
        greaterThan:(NSNumber*) number;

/**
 Add a greater than or equal to criteria.
 @param searchField Search field
 @param number Number
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
 greaterOrEqualThan:(NSNumber*) number;

/**
 Add a like criteria.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
               like:(NSString*) string;

/**
 Add a not like criteria.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
            notLike:(NSString*) string;

/**
 Add a like criteria that matches only left of the input.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
           leftLike:(NSString*) string;

/**
 Add a not like criteria that matches only left of the input.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
        notLeftLike:(NSString*) string;

/**
 Add a like criteria that matches only right of the input.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
          rightLike:(NSString*) string;

/**
 Add a not like criteria that matches only right of the input.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
       notRightLike:(NSString*) string;

/**
 Add an equal to criteria.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
              equal:(NSString*) string;

/**
 Add a not equal to criteria.
 @param searchField Search field
 @param string String
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
           notEqual:(NSString*) string;

/**
 Add an in criteria.
 @param searchField Search field
 @param values Array of strings
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
           insideValues:(NSArray*) values;

/**
 Add a not in criteria.
 @param searchField Search field
 @param values Array of strings
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
        notInsideValues:(NSArray*) values;

/**
 Add a between criteria.
 @param searchField Search field
 @param number1 First number in the range
 @param number2 Last number in the range
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
            between:(NSNumber*) number1
                and:(NSNumber*) number2;

/**
 Add a not between criteria.
 @param searchField Search field
 @param number1 First number in the range
 @param number2 Last number in the range
 @since IBM Worklight V6.2.0
 */
-(void) searchField:(NSString*) searchField
         notBetween:(NSNumber*) number1
                and:(NSNumber*) number2;
@end
