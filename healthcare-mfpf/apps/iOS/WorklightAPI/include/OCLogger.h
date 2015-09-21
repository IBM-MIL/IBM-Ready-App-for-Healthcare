/*
 *  Licensed Materials - Property of IBM
 *  5725-I43 (C) Copyright IBM Corp. 2011, 2013. All Rights Reserved.
 *  US Government Users Restricted Rights - Use, duplication or
 *  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */

#import <Foundation/Foundation.h>

typedef enum {
    OCLogger_TRACE = 600,
    OCLogger_DEBUG = 500,
    OCLogger_LOG = 400,
    OCLogger_INFO = 300,
    OCLogger_WARN = 200,
    OCLogger_ERROR = 100,
    OCLogger_FATAL = 50,
    OCLogger_ANALYTICS = 25
} OCLogType;


/**
 * Contains OCLogger methods that manage client side logs.
 */
@interface OCLogger : NSObject

@property (atomic,strong) NSString* package;

//Instance methods (no context)

/**
 This method logs at TRACE level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) trace: (NSString*) text, ...;

/**
 This method logs at DEBUG level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) debug: (NSString*) text, ...;

/**
 This method logs at LOG level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) log: (NSString*) text, ...;

/**
 This method logs at INFO level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) info: (NSString*) text, ...;

/**
 This method logs at WARN level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) warn: (NSString*) text, ...;

/**
 This method logs at ERROR level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) error: (NSString*) text, ...;

/**
 This method logs at FATAL level.
 @param String message to be logged
 @since IBM Worklight V6.2.0
 */
-(void) fatal: (NSString*) text, ...;


//Instance methods (with context)

/**
 This method logs at TRACE level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata trace: (NSString*) text, ...;

/**
 This method logs at DEBUG level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata debug: (NSString*) text, ...;

/**
 This method logs at LOG level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata log: (NSString*) text, ...;

/**
 This method logs at INFO level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata info: (NSString*) text, ...;

/**
 This method logs at WARN level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata warn: (NSString*) text, ...;

/**
 This method logs at ERROR level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata error: (NSString*) text, ...;

/**
 This method logs at FATAL level.
 @param String message to be logged
 @param metadata Dictionary containing metadata to append to the log output
 @since IBM Worklight V6.2.0
 */
-(void) metadata:(NSDictionary*) metadata fatal: (NSString*) text, ...;

//Static methods

/**
 This method gets or creates an instance of this logger. If an instance exists for the package parameter, that instance is returned.
 @param package String denoting package or tag that must be printed with log messages. The value is passed through to NSLog and recorded when log capture is enabled.
 @return OCLogger instance used to create subsequent log calls
 @since IBM Worklight V6.2.0
 */
+(OCLogger*) getInstanceWithPackage: (NSString*) package;

/**
 This method sends the log file when the log buffer exists and is not empty.
 @since IBM Worklight V6.2.0
 */
+(void) send;

/**
 This method sends the log file when the log buffer exists, the log is not empty, and an uncaught exception occurred.
 @since IBM Worklight V6.2.0
 */
+(void) sendIfUnCaughtExceptionDetected;

/**
 This method gets the current setting for determining if log data should be saved persistently.
 @return Boolean flag indicating whether the log data must be saved persistently
 @since IBM Worklight V6.2.0
 */
+(BOOL) getCapture;

/**
 Global setting: turn persisting of the log data that is passed to the log methods of this class, on or off.
 @param Boolean flag to indicate whether the log data must be saved persistently
 @since IBM Worklight V6.2.0
 */
+(void) setCapture: (BOOL) flag;


/**
 This method will retrieve the filters that are used to determine which log messages are persisted.
 @return Dictionary defining the logging filters
 @since IBM Worklight V6.2.0
 */
+(NSDictionary*) getFilters;

/**
 This method sets the filters that are used to determine which log messages are persisted. Each key defines a package name and each value defines a logging level.
 @param Dictionary containing the package name and logging level key value pairs that are used to filter persisted logs
 @since IBM Worklight V6.2.0
*/
+(void) setFilters: (NSDictionary*) filters;

/**
 This method gets the current setting for the maximum file size threshold.
 @return int indicating the maximum file size threshold
 @since IBM Worklight V6.2.0
 */
+(int) getMaxFileSize;

/**
 This method sets the maximum size of the local log file. When the maximum file size is reached, no more data is appended. This file is sent to a server.
 @param int defining the maximum size of the file in bytes, the minimum is 10,000 bytes.
 @since IBM Worklight V6.2.0
 */
+(void) setMaxFileSize: (int) bytes;

/**
 This method gets the current OCLogger_LEVEL and returns OCLogger_LEVEL.
 @return OCLogType for the current log level
 @since IBM Worklight V6.2.0
 */
+(OCLogType) getLevel;

/**
 This method sets the level from which log messages must be saved and printed. For example, passing OCLogger_INFO logs INFO, WARN, and ERROR.
 @param level OCLogType The valid values of this input parameter are OCLogger_DEBUG, OCLogger_ERROR, OCLogger_INFO, OCLogger_LOG, and OCLogger_WARN.
 @since IBM Worklight V6.2.0
 */
+(void) setLevel: (OCLogType) level;

/**
 Global setting: Turn automatic sending of client logs on or off
 @param Boolean flag determining whether or not logs are automatically forwarded to the server
 @since IBM Worklight V6.2.0
 */
+(void) setAutoSendLogs: (BOOL) flag;

/**
 Global setting: Turn automatic retrieval of configuration profiles from the server
 @param Boolean flag determining whether or not configuration profiles will be automatically retrieved from the server
 @since IBM Worklight V6.2.0
 @deprecated V6.3.0
 */
+(void) setAutoUpdateConfigFromServer: (BOOL) flag;

/**
 This method indicates that an uncaught exception was detected.  The indicator is cleared on successful send.
 @since IBM Worklight V6.2.0
 */
+(BOOL) isUnCaughtExceptionDetected;

@end
