/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLArea_H_
#import <Foundation/Foundation.h>
@protocol AreaVisitor;

/**
 * @ingroup geo
 * This protocol provides the parent interface for geometric shapes.
 */
@protocol WLArea <NSObject> 

/**
	 * @param visitor
	 * @return the visitor's return value
	 * @exclude
	 */
- (NSObject*) accept : (id<AreaVisitor>) visitor ;

@end

