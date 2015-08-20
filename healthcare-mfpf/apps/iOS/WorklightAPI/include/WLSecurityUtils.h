/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#import <Foundation/Foundation.h>

/**
 IBM MobileFirst Platform Security Utilities.
 @since IBM Worklight V6.2.0
 */
@interface WLSecurityUtils : NSObject

/**
 Generates a key by using the PBKDF2 algorithm.
 @param pass The password that is used to generate the key
 @param salt The salt that is used to generate the key
 @param iterations The number of iterations that is passed to the key generation algorithm
 @param error Error
 @return The generated key.
 @since IBM Worklight V6.2.0
 */
+(NSString*) generateKeyWithPassword: (NSString *) pass
                             andSalt: (NSString *) salt
                       andIterations: (NSInteger) iterations
                               error: (NSError**) error;

/**
 Encrypts text with a key.
 @param text The text to encrypt
 @param key The key used for encryption
 @param error Error
 @return An NSDictionary with the cipher text (ct), the IV (iv), the source (src) and the version (v).
 @since IBM Worklight V6.2.0
 */
+(NSDictionary*) encryptText: (NSString*) text
                     withKey: (NSString*) key
                       error: (NSError**) error;

/**
 Decrypts a dictionary that contains: src (source), v (version), ct (cipher text) and the iv (initialization vector).
 @param ciphertext The encrypted text to decrypt
 @param key The key used for decryption
 @param encryptedObj NSDictionary that is returned from encryptText:withKey:error:
 @param error Error
 @return The decrypted text
 @since IBM Worklight V6.2.0
 */
+(NSString*) decryptWithKey: (NSString*) key
              andDictionary:(NSDictionary*) encryptedObj
                      error: (NSError**) error;

/**
 Gets a random string from the server.
 @param bytes Number of bytes that are used to generate the random string (maximum 64 bytes)
 @param timeout The time to wait for the network request to finish
 @param handler Called when the request finished, the data field will have the random string (NSUTF8StringEncoding)
 @since IBM Worklight V6.2.0
 */
+(void) getRandomStringFromServerWithBytes:(int)bytes
                                   timeout:(int)timeout
                         completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

/**
 Generates a random string locally.
 @param bytes Number of bytes that is used to generate the random string
 @return The random string, nil if the operation fails
 @since IBM Worklight V6.2.0
 */
+(NSString*) generateRandomStringWithBytes:(int) bytes;

/**
 Encodes data to an NSString with Base64 encoding.
 @param data Data
 @param length Length of the input
 @return Base64 encoded NSString
 @since IBM Worklight V6.2.0
 */
+ (NSString*) base64StringFromData:(NSData*) data
                             length:(int) length;

/**
 Takes an NSString and returns Base64 encoded NSData.
 @param string Input NSString
 @return Base64 encoded NSData
 @since IBM Worklight V6.2.0
 */
+ (NSData*) base64DataFromString:(NSString*) string;

/**
 Reads Base64 encoded file and writes decoded output to output file
 @param handleInput Handle to input file; the caller is responsible for closing the file
 @param outputFileName Full path to output file
 @param stripFileLenPrefix Specifies that the input file is Base64 encoded file downloaded by Direct Update and contains prefix in format {fileLength:xxx}@@@, which should be stripped by the algorithm
 @since IBM Worklight V6.2.0
 */
+(void) decodeBase64WithFiles:(NSFileHandle*) handleInput output:(NSString*) outputFileName;

+(NSData*) _decodeBase64WithString:(NSString*) strBase64;

+ (BOOL) verifyPayloadWithSignedData:(NSData *)payloadData signedDataBase64:(NSString*)dataBase64;
+ (BOOL) checkPublicKeyValidity;
+ (BOOL)verifySignature:(NSData *)plainText secKeyRef:(SecKeyRef)publicKey signature:(NSData *)sig;

+ (NSData *) sha1FromFile:(NSString *)path;
+ (NSData *) sha256FromFile:(NSString *)path;

+(NSString *)readSignatureWithLength:(int)length withPath:(NSString*) path;

+(int)padFileLastBytes:(int)nBytesFromEndOfFile withPaddingChar:(char)padd filePath:(NSString*) path;
@end
