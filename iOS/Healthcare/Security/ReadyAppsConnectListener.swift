/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.

*/

import Foundation

/**
This class is a listener for ReadyAppsAuthenticator. It handles the success/failures relating to the user login
*/
class ReadyAppsConnectListener : NSObject, WLDelegate {

    var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
    
    override init() {
       
    }
    
    /**
    Handles the login user success scenario
    */
    func onSuccess(response: WLResponse!) {
        print("onSuccess in ConnectListener")
        print("Successfully connected to MobileFirst Server. Response: \(response)");
    }
    
    /**
    Handles the login user failure scenario
    */
    func onFailure(response: WLFailResponse!) {
        print("onFailure in ConnectListener")
        print("Failed connecting to MobileFirst Server. Response: \(response)");
        appDelegate.loginViewController.showAlertForServerConnectionFailure()
    }
}