/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLClient.h
//  Worklight SDK
//
//  Created by Benjamin Weingarten on 3/4/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLDelegate.h"
#import "BaseChallengeHandler.h"

@class WLCookieExtractor;
@class WLRequest;
@class WLProcedureInvocationData;
@class WLEventTransmissionPolicy;

extern NSString * const WL_DEFAULT_ACCESS_TOKEN_SCOPE;

@protocol WLDevice;


/**
 * @ingroup main
 * This singleton class exposes methods that you use to communicate with the IBM MobileFirst Platform Server.
 */
@interface WLClient : NSObject {
    
@private
	
	// PUSH NOTIFICATION
	NSMutableArray *pending;
	NSMutableDictionary *registeredEventSourceIDs;
    
    //Challenge handlers
    NSMutableDictionary *challengeHandlers;
    
    // Location Services
    id<WLDevice> wlDevice;
	
	// Cached access tokens map
	NSMutableDictionary *wlAccessTokens;
    
    BOOL isInitialized;
}

extern NSMutableDictionary *piggyBackData;

/**
 * @description
 * Sets an authentication handler that WLClient can use for authentication-related tasks. 
 * This method must be called for WLClient to be able to access protected resources in the IBM MobileFirst Platform server.
 */
@property (nonatomic, strong) NSMutableDictionary *registeredEventSourceIDs;

@property (nonatomic) BOOL isInitialized;

@property (readwrite) NSInteger interval;

@property (readwrite, strong) NSTimer *timer;

@property (nonatomic) BOOL isResumed;

@property (nonatomic) BOOL isRequestFailed;

@property (readwrite, strong) NSMutableDictionary *userPreferenceMap;

+ (WLClient *) sharedInstance;

/**
 * This method uses the connection properties and the application ID from the worklight.plist file to initialize communication with the IBM MobileFirst Platform Server.
 * The server checks the validity of the application version.
 *
 * @note This method must be called before any other WLClient method that calls the server, such as <code>logActivity</code> and <code>invokeProcedure.</code>
 *
 * @par If the server returns a successful response, the <code>onSuccess</code> method is called. If an error occurs, the <code>onFailure</code> method is called.
 *
 * @param delegte
 * A class that conforms to the WLDelegate protocol.
 * @param cookieExtractor
 * Optional, can be nil. Used to share the cookies between the native code and the web code in the app.
 */
-(void) wlConnectWithDelegate:(id <WLDelegate>)delegte cookieExtractor:(WLCookieExtractor *) cookieExtractor;

/**
 * This method uses the connection properties and the application ID from the worklight.plist file to initialize communication with the IBM MobileFirst Platform Server.
 * The server checks the validity of the application version.
 *
 * @note This method must be called before any other WLClient method that calls the server, such as <code>logActivity</code> and <code>invokeProcedure.</code>
 *
 * @par If the server returns a successful response, the <code>onSuccess</code> method is called. If an error occurs, the <code>onFailure</code> method is called.
 *
 * @param delegte A class that conforms to the WLDelegate protocol.
 */
-(void) wlConnectWithDelegate:(id <WLDelegate>)delegte;

/**
 * This method uses the connection properties and the application ID from the worklight.plist file to initialize communication with the IBM MobileFirst Platform Server.
 * The server checks the validity of the application version.
 * This method accepts a "timeout" key in its options parameter -  (NSNumber) Number of milliseconds to wait for the server response before the request times out.
 *
 * @note This method must be called before any other WLClient method that calls the server, such as <code>logActivity</code> and <code>invokeProcedure.</code>
 *
 * @par If the server returns a successful response, the <code>onSuccess</code> method is called. If an error occurs, the <code>onFailure</code> method is called.
 *
 * @param delegate A class that conforms to the WLDelegate protocol.
 * @param options Optional, can be nil. Used to set the timeout while connecting to the server. In this dictionary the user puts key "timeout" (milliseconds).
 */
-(void) wlConnectWithDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;

/**
 * Invokes an adapter procedure. This method is asynchronous.
 * The response is returned to the callback functions of the provided delegate.
 * If the call succeeds, <code>onSuccess</code> is called. If it fails, <code>onFailure</code> is called.
 * <p>
 * Example:
 * <p> The following code invokes a procedure "getStoriesFiltered" in the adapter "RSSReader" using a parameter "Africa":
 * <pre>
 * WLProcedureInvocationData *myInvocationData = [[WLProcedureInvocationData alloc] initWithAdapterName:@"RSSReader" procedureName:@"getStoriesFiltered"];
 * myInvocationData.parameters = [NSArray arrayWithObjects:@"Africa", nil];
 * </pre>
 * @param invocationData The invocation data for the procedure call.
 * @param delegate The delegate object that is used for the onSuccess and onFailure callback methods.
 *
 */
-(void) invokeProcedure:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate;

/**
 * This method is similar to invokeProcedure:invocationData:withDelegate, with an additional options parameter to provide more data for this procedure call.
 *
 * @param invocationData The invocation data for the procedure call.
 * @param delegate The delegate object that is used for the onSuccess and onFailure callback methods.
 * @param options A map with the following keys and values:
 * timeout – NSNumber:
 * The time, in milliseconds, for this invokeProcedure to wait before the request fails with WLErrorCodeRequestTimeout. The default timeout is 10 seconds. To disable the timeout, set this parameter to 0.
 *
 * invocationContext:
 * An object that is returned with WLResponse to the delegate methods. You can use this object to distinguish different invokeProcedure calls.
 */
-(void) invokeProcedure:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;


-(void) sendInvoke:(WLProcedureInvocationData *)invocationData withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options ignoreChallenges: (BOOL)ignoreChallenges;

/**
 * This method subscribes the application to receive push notifications from the specified event source and adapter.
 *
 * @param deviceToken The token received from the method application:didRegisterForRemoteNotificationsWithDeviceToken. Save the device token in case unsubscribedWithToken:adapter:eventSource:delegate: is called.
 * @param adapter The name of the adapter.
 * @param eventSource The name of the event source.
 * @param eventSourceID An ID that you assign to the event source that is returned by the IBM MobileFirst Platform Server with each notification from this event source. You can use the ID in your notification callback function to identify the notification event source.
 * The ID is passed on the notification payload. To save space in the notification payload, pass a short integer, otherwise it is used to pass the adapter and event source names.
 * @param notificationType Constants that indicate the types of notifications that the application accepts. For more information, see the <a href="http://developerns.apple.com/library/ios/" \l "documentation/UIKit/Reference/UIApplication_Class/Reference/Reference.html"> link Apple documentation.</a>
 * @param delegate A standard IBM MobileFirst Platform delegate with onSuccess and onFailure methods to indicate success or failure of the subscription to the IBM MobileFirst Platform Server.
 */
-(void) subscribeWithToken:(NSData *)deviceToken adapter:(NSString *)adapter eventSource: (NSString *)eventSource eventSourceID: (int)eventSourceID notificationType:(UIRemoteNotificationType) types delegate:(id <WLDelegate>)delegate;

/**
 * This method subscribes the application to receive push notifications from the specified event source and adapter.
 *
 * @param deviceToken The token received from the method application:didRegisterForRemoteNotificationsWithDeviceToken. Save the device token in case unsubscribedWithToken:adapter:eventSource:delegate: is called.
 * @param adapter The name of the adapter.
 * @param eventSource The name of the event source.
 * @param eventSourceID An ID that you assign to the event source that is returned by the IBM MobileFirst Platform Server with each notification from this event source. You can use the ID in your notification callback function to identify the notification event source.
 * The ID is passed on the notification payload. To save space in the notification payload, pass a short integer, otherwise it is used to pass the adapter and event source names.
 * @param notificationType Constants that indicate the types of notifications that the application accepts. For more information, see the <a href="http://developerns.apple.com/library/ios/" \l "documentation/UIKit/Reference/UIApplication_Class/Reference/Reference.html"> link Apple documentation.</a>
 * @param delegate A standard IBM MobileFirst Platform delegate with onSuccess and onFailure methods to indicate success or failure of the subscription to the IBM MobileFirst Platform Server.
 * @param options Optional. This parameter contains data that is passed to the IBM MobileFirst Platform Server, which is used by the adapter.
 */
-(void) subscribeWithToken:(NSData *)deviceToken adapter:(NSString *)adapter eventSource: (NSString *)eventSource eventSourceID: (int)eventSourceID notificationType:(UIRemoteNotificationType) types delegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;

/**
 * This method unsubscribes to notifications from the specified event source in the specified adapter.
 *
 * @param adapter The name of the adapter.
 * @param eventSource TThe name of the event source.
 * @param delegate A standard IBM MobileFirst Platform delegate with the onSuccess and onFailure methods to indicate success or failure of the unsubscription to the IBM MobileFirst Platform Server.
 */
-(void) unsubscribeAdapter:(NSString *)adapter eventSource: (NSString *)eventSource delegate:(id <WLDelegate>)delegate;

/**
 * This method returns true if the current logged-in user on the current device is already subscribed to the adapter and event source. 
 * The method checks the information received from the server in the success response for the login request. If the information that is sent from the server is not received, or if there is no subscription, this method returns false.
 *
 * @param adapter The name of the adapter.
 * @param eventSource TThe name of the event source.
 */
-(BOOL) isSubscribedToAdapter:(NSString *)adapter eventSource:(NSString *)eventSource;

/**
 * This method compares the device token to the one registered in the IBM MobileFirst Platform Server with the current logged-in user and current device. If the device token is different, the method sends the updated token to the server.
 *
 * The registered device token from the server is received in the success response for the login request. It is available without the need for an additional server call to retrieve. If a registered device token from the server is not available in the application, this method sends an update to the server with the device token.
 *
 * @param deviceToken The token received from the method <code>application:didRegisterForRemoteNotificationsWithDeviceToken</code>. Save the device token in case <code>unsubscribedWithToken:adapter:eventSource:delegate</code> is called.
 * @param delegate A standard IBM MobileFirst Platform delegate with the onSuccess and onFailure methods to indicate success or failure of the unsubscription to the IBM MobileFirst Platform Server.
 */
-(void) updateDeviceToken:(NSData *)deviceToken  delegate:(id <WLDelegate>)delegate;

/**
 * This method returns the eventSourceID that the IBM MobileFirst Platform Server sends in the push notification.
 *
 * @param userInfo The NSDictionary received in the application:didReceiveRemoteNotification method.
 */
-(int) getEventSourceIDFromUserInfo:(NSDictionary *)userInfo;

//-(void)setUserPref:(NSString *)key :(NSString *)value :(id<WLDelegate>)responseListener :(NSMutableDictionary *)options;
//-(void)setUserPrefs :(NSMutableDictionary *)userPrefMap :(id<WLDelegate>)responseListener :(NSMutableDictionary *)options;
//-(void) deleteUserPref :(NSString *)key :(id<WLDelegate>)responseListener :(NSMutableDictionary *)options;
//-(NSString *)getUserPref :(NSString *)key;
//-(BOOL) hasUserPref :(NSString *)key;

/**
 * This method reports a user activity for auditing or reporting purposes.
 *
 * The activity is stored in the application statistics tables (the GADGET_STAT_N tables).
 *
 * @param activityType A string that identifies the activity.
 */
-(void) logActivity:(NSString *) activityType;

/**
 * You can use this method to register a custom Challenge Handler, which is a class that inherits from ChallengeHandler. See example 1: Adding a custom Challenge Handler.
 * You can also use this method to override the default Remote Disable / Notify Challenge Handler, by registering a class that inherits from WLChallengeHandler. See example <a href=""> link  2: Customizing the Remote Disable / Notify.</a>
 *
 * @param challengeHandler The Challenge Handler to register.
 */
-(void) registerChallengeHandler: (BaseChallengeHandler *) challengeHandler;

/**
 * You use this method to add a global header, which is sent on each request.
 * Each WlRequest instance will use this header as an HTTP header
 *
 * @param headerName The header name/key.
 * @param value The header value.
 */
-(void) addGlobalHeader: (NSString *) headerName headerValue:(NSString *)value;

/**
 * You use this method to remove a global header, which is no longer sent with each request.
 *
 * @param headerName The header name to be removed.
 */
-(void) removeGlobalHeader: (NSString *) headerName;

/**
 * get a global header.
 */
-(NSDictionary *) getGlobalHeaders;


/**
 * Get challenge handler by realm key
 */
-(BaseChallengeHandler *) getChallengeHandlerByRealm: (NSString *) realm;


-(NSDictionary *) getAllChallengeHandlers;

/**
 * This method sets the interval, in seconds, at which the client (device) sends a heartbeat signal to the server. 
 * <p>
 * You use the heartbeat signal to prevent a session with the server from timing out because of inactivity. Typically, the heartbeat interval has a value that is less than the server session timeout.The server session timeout is defined in the worklight.properties file. By default, the value of the heartbeat interval is set to 420 seconds (7 minutes).
 * To disable the heartbeat signal, set a value that is less than, or equal to zero.
 *
 * @note The client sends a heartbeat signal to the server only when the application is in the foreground. When the application is sent to the background, the client stops sending heartbeat signals. The client resumes sending heartbeat signals when the application is brought to the foreground again.
 *
 * @param val The interval, in seconds, at which the heartbeat signal is sent to the server.
 */
-(void) setHeartBeatInterval :(NSInteger)val;

/**
 * Gets the WLDevice instance
 */
-(id<WLDevice>) getWLDevice;


/**
 * Equivalent to <code>[transmitEvent: eventJson immediately: NO]</code>
 * @param event - the event to be transmitted.
 */
- (void) transmitEvent: (NSMutableDictionary*) eventJson;

/**
 * Transmits a provided event object to the server.
 * <p>
 * An event object is added to the transmission buffer. The event object is either transmitted immediately,
 * if the immediate parameter is set to <code>true</code>, otherwise it is transmitted according to the transmission policy.
 * For more information, see <code>WL.Client.setEventTransmissionPolicy</code>. One of the properties for the event object might be the device context, which comprises geo-location and WiFi data.
 * If no device context is transmitted as part of the event, the current device context, as returned by <code>WL.Device.getContext</code>, is added automatically to the event during the transmission process.
 *
 * @param eventJson - The event object that is being transmitted. The event object is either a literate object, or a reference to an object.
 * @param immediately - A boolean flag that indicates whether the transmission should be immediate (<code>true</code>), or should be based on the transmission policy's interval (<code>false</code>).
 *                        If immediate is <code>true</code>, previously buffered events are transmitted, as well as the current event. The default value is <code>false</code>.
 */
- (void) transmitEvent: (NSMutableDictionary*) eventJson immediately: (BOOL) immediately;

/**
 * Configures the transmission of events from the client to the server, according to the provided transmission policy.
 *
 * @param policy The policy instance which will be used.
 */
- (void) setEventTransmissionPolicy: (WLEventTransmissionPolicy*) policy;


/**
 * Sets the IBM MobileFirst Platform server URL to the specified URL
 * <p>
 * Changes the IBM MobileFirst Platform server URL to the new URL and cleans the HTTP client context.
 * After calling this method, the application is not logged in to any server.
 * <p>
 * Notes:
 * <ul>
 * <li>The responsibility for checking the validity of the URL is on the developer.
 * <li>For hybrid applications: This call does not clean the HTTP client context saved in JavaScript.
 * For hybrid applications, it is recommended to set the server URL by using the following JavaScript function: <code>WL.App.setServerUrl</code>.
 * <li>If the app uses push notification, it is the developer's responsibility to unsubscribe from the previous server and subscribe to the new server.
 * For more information on push notification, see <code>WLPush</code>.
 * </ul>
 *
 * Example:
 * <code>[[WLClient sharedInstance] setServerUrl:[NSURL URLWithString:@"http://9.148.23.88:10080/context"]];</code>
 *
 * @param url - The URL of the new server, including protocol, IP, port, and context.
 *
 */
- (void) setServerUrl: (NSURL*) url;

/**
 * Returns the current IBM MobileFirst Platform server URL
 *
 * @return IBM MobileFirst Platform server URL
 */
- (NSURL*) serverUrl;

/**
 * Purges the internal event transmission buffer.
 * <p>
 * The internal event transmission buffer is purged, and all events awaiting transmission are permanently lost.
 */
- (void) purgeEventTransmissionBuffer;

/**
 * This method logs in to a specific realm. It is an asynchronous function.
 * You must specify the realm name and a wlDelegate instance for accepting onSuccess and onFailure events.
 * A default timeout of 60 seconds is used for waiting for the server to respond before the request times out.
 *
 * @param realmName - the realm name to log in to
 * @param delegate - implements wlDelegate protocol (which has onSuccess and onFailure methods)
**/
- (void) login:(NSString *) realmName withDelegate:(id <WLDelegate>)delegate;

/**
 * This method logs in to a specific realm. It is an asynchronous function.
 * You must specify the realm name and a wlDelegate instance for accepting onSuccess and onFailure events.
 * This method accepts a "timeout" key in its options parameter -  (NSNumber) Number of milliseconds to wait for the server response
 * before the request times out.
 *
 * @param realmName - the realm name to log in to
 * @param delegate - implements wlDelegate protocol (which has onSuccess and onFailure methods)
 * @param options - in this dictionary - the user puts the key "timeout" (milliseconds)
**/
- (void) login:(NSString *) realmName withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;


/**
 * This method logs out of a specific realm. It is an asynchronous function.
 * You must specify the realm name and a wlDelegate instance for accepting onSuccess and onFailure events.
 * A default timeout of 60 seconds is used for waiting for the server to respond before the request times out
 *
 * @param realmName - the realm name to logout from
 * @param delegate - implements wlDelegate protocol (which has onSuccess and onFailure methods)
**/
- (void) logout:(NSString *) realmName withDelegate:(id <WLDelegate>)delegate;

/**
 Returns the last obtained access token (regardless of scope), or <code>null</code> if no tokens were previosly obtained.
 */
- (NSString*) lastAccessToken;

/**
 Returns the last obtained access token for a specific scope, or <code>null</code> if no tokens were previously obtained
 for the given scope.
 
 @param scope The scope of the requested token.
 */
- (NSString*) lastAccessTokenForScope:(NSString*)scope;

/**
 Obtains an oauth 2.0 access token from the IBM MobileFirst Platform server. The token is required in order to send a request
 to an external server which uses this IBM MobileFirst Platform authentication method.
 This method is asynchronous; the response is returned to the supplied delegate callback functions.
 
 Note that there is no need to parse the response for the access token. Instead, use <code>WL.Client.lastAccessToken</code>
 or <code>WL.Client.lastAccessTokenForScope</code> in order to get the last obtained token.
 
 @param delegate  - WLDelegate. Implements the callback methods onSuccess and onFailure.
 
 @exception NSException raised if scope or delegate are nil. 
 */
- (void) obtainAccessTokenForScope:(NSString*)scope withDelegate:(id<WLDelegate>)delegate;

/**
 Obtains an oauth 2.0 access token from the IBM MobileFirst Platform server. The token is required in order to send a request
 to an external server which uses this IBM MobileFirst Platform authentication method.
 This method is asynchronous; the response is returned to the supplied delegate callback functions.
 
 Note that there is no need to parse the response for the access token. Instead, use <code>WL.Client.lastAccessToken</code>
 or <code>WL.Client.lastAccessTokenForScope</code> in order to get the last obtained token.
 
 @param delegate  - WLDelegate. Implements the callback methods onSuccess and onFailure.
 @param options A dictionary for which the following key can contain a value:
 "timeout" - NSNumber. time in miliseconds for this invokeProcedure to wait before failing with WLErrorCodeRequestTimeout
 
 @exception NSException raised if scope or delegate are nil. 
 */
- (void) obtainAccessTokenForScope:(NSString*)scope withDelegate:(id<WLDelegate>)delegate options:(NSDictionary*) options;

/**
 Determines whether an access token is requested by the server, and returns the required scope, or
 null if the response is not related to IBM MobileFirst Platform tokens.
 
 @param status The status code of the response.
 @param authenticationHeader The value of the <code>WWW-Authenticate</code> header of the response.
 */
- (NSString*) getRequiredAccessTokenScopeFromStatus:(int)status authenticationHeader:(NSString*)authHeader;

/**
 * This method logs out of a specific realm. It is an asynchronous function.
 * You must specify the realm name and a wlDelegate instance for accepting onSuccess and onFailure events.
 * This method accepts a "timeout" key in its options parameter - (NSNumber) Number of milliseconds to wait for the server response
 * before the request times out.
 *
 * @param realmName - the realm name to logout from
 * @param delegate - implements wlDelegate protocol (which has onSuccess and onFailure methods)
 * @param options - in this dictionary - the user puts the key "timeout" (milliseconds)
**/
- (void) logout:(NSString *) realmName withDelegate:(id <WLDelegate>)delegate options:(NSDictionary *)options;

@end
