/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>
#import "JSONStoreCollection.h"
#import "JSONStoreOpenOptions.h"

/**
 Contains JSONStore methods that operate on the store.
 @since IBM Worklight V6.2.0
 */
@interface JSONStore : NSObject

/**
 Private. Dictionary that holds JSONStoreCollection objects.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic, strong) NSMutableDictionary* _accessors;

/**
 Private. Boolean that determines if analytics are logged or not.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic) BOOL _analytics;

/**
 Private. Boolean that determines if a transaction is running or not.
 @since IBM Worklight V6.2.0
 */
@property (nonatomic) BOOL _transactionActive;

/**
 Provides access to methods that operate on a store.
 @return self
 @since IBM Worklight V6.2.0
 */
+(JSONStore*) sharedInstance;

/**
 Provides access to the collections inside the store, and creates them if they do not already exist.
 @param collections NSArray of JSONStoreCollection instances
 @param options Options
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) openCollections: (NSArray*) collections
            withOptions: (JSONStoreOpenOptions*) options
                  error: (NSError**) error;

/**
 Provides an accessor to the collection if the collection exists. This depends on openCollections:withOptions:error: being called first, with the collection requested.
 @param collectionName Name of the opened collection
 @return Accessor to a single collection
 @since IBM Worklight V6.2.0
 */
-(JSONStoreCollection*) getCollectionWithName: (NSString*) collectionName;

/**
 Locks access to all the collections until openCollections:withOptions:error: is called.
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) closeAllCollectionsAndReturnError:(NSError**) error;

/**
 Permanently deletes all data for a specific user, clears security artifacts, and removes accessors.
 @param username Username for the store to remove
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.3.0
 */
-(BOOL) destroyWithUsername:(NSString*)username error:(NSError**)error;

/**
 Permanently deletes all data for all users, clears security artifacts, and removes accessors.
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) destroyDataAndReturnError:(NSError**) error;

/**
 Changes the password that is associated with the security artifacts that are used to provide data encryption.
 @param oldPassword The old password
 @param newPassword The new password
 @param username The username
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) changeCurrentPassword: (NSString*) oldPassword
              withNewPassword: (NSString*) newPassword
                  forUsername: (NSString*) username
                        error: (NSError**) error;

/**
 Returns information about the file that is used to persist data in the store.
 @param error Error
 @return NSDictionary with information about the store. Returns the following key value pairs: name - name of the store, size - the total size, in bytes, of the store, and isEncrypted - boolean that is true when encrypted and false otherwise
 @since IBM Worklight V6.2.0
 */
-(NSArray*) fileInfoAndReturnError:(NSError**) error;

/**
 Starts a transaction.
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) startTransactionAndReturnError:(NSError**) error;

/**
 Commits a transaction.
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) commitTransactionAndReturnError:(NSError**) error;

/**
 Rolls back a transaction.
 @param error Error
 @return Boolean that indicates the operation failed (false) or succeeded (true)
 @since IBM Worklight V6.2.0
 */
-(BOOL) rollbackTransactionAndReturnError:(NSError**) error;

@end
