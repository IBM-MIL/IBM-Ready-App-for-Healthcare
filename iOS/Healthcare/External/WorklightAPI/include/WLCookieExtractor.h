/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

//
//  WLCookieExtractor.h
//  Worklight SDK
//
//  Created by Benny Weingarten on 11/24/10.
//  Copyright (C) Worklight Ltd. 2006-2012.  All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @ingroup main
 * This class provides access to external cookies that WLClient can use when it issues requests to the IBM MobileFirst Platform Server. You use this class to share session cookies between a web view and a natively implemented page.
 * This class has no API methods. An object of this class must be passed as a parameter to <code>wlConnectWithDelegate:cookieExtractor</code>.

 */
@interface WLCookieExtractor : NSObject {

}

-(id)initWithWebView:(UIWebView *)webview;
-(NSDictionary *)getCookies;


@end
