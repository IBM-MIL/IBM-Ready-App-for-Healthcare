/*
 * Licensed Materials - Property of IBM
 * 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

//
//  WLDeviceAuthManager.h
//  WorklightStaticLibProject
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface WLDeviceAuthManager : NSObject

/**
 * Get the DeviceAuthManager singleton instance 
 */
+ (WLDeviceAuthManager *) sharedInstance;

/**
 * Get the alias used for client user x509 certificate.  Entity is currently not used.
 */
+ (NSString *) getAlias:(NSString *)entity;

/**
 * Get certififacte Label as used when saved in keychain.
 */
+ (NSData *) getCertificateIdentifierFromEntity:(NSString *)provisioningEntity;

/**
 * Get private/public key Label as used when saved in keychain.
 */
+ (NSData *) getKeyIdentifier:(BOOL)isPublic withEntity:(NSString *)provisioningEntity;

/**
 * This method signs on a given content according to JSW standard.
 * We'll using the public key
 * Sign the header and payload with SHA256 / RSA 512 
 * payloadJSON- NSMutableDictionary with the content sign on.
 * return - the signed string.
 */
+ (NSString *) signDeviceAuth:(NSDictionary *) payloadJSON entity:(NSString *) provisioningEntity isPEnabled:(BOOL) isProvisioningEnabled;

//Call this initializer only
-(WLDeviceAuthManager *) init;
-(NSString *) createUUID;
-(NSString *) getWLUniqueDeviceId;

/**
 * Cleans Device Provisioning Certificate from KeyChain
 */
+ (BOOL) clearDeviceCertCredentialsFromKeyChain:(NSString *)provisioningEntity;


@end

