/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.

*/

import Foundation

/**
This class is a listener for ReadyAppsAuthenticator. It handles the success/failures relating to the user logout
*/
class ReadyAppsLogoutListener : NSObject, WLDelegate {
    
    var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
    
    override init() {
        
    }
    
    /**
    Handles the logout user success scenario
    */
    func onSuccess(response: WLResponse!) {
        println("onSuccess in LogoutListener")
        println("Successfully loggeed out of MobileFirst Server. Response: \(response)");
        appDelegate.isLogoutSuccess = true
    }
    
    /**
    Handles the logout user failure scenario
    */
    func onFailure(response: WLFailResponse!) {
        println("onFailure in LogoutListener")
        println("Failed logging out of MobileFirst Server. Response: \(response)");
        appDelegate.isLogoutSuccess = false
    }
}