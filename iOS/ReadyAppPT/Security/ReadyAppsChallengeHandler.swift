/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.

*/

import Foundation

/**
This class interacts with the MobileFirst Server to authenticate the user upon login. If the user has been timed out,
it will present the user with the login view controller, so they can login.
*/
class ReadyAppsChallengeHandler : ChallengeHandler {
    // class definition goes here
    
    var firstTimeLogin : Bool
    var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
    var exerciseListViewController : ExerciseListViewController!
    var formsListViewController : FormsViewController!
    var dashboardViewController : DashboardViewController!
    var isExerciseListView : Bool
    var isFormsView : Bool
    var loginViewController : LoginViewController!
    var isUserTimedOut : Bool = false
    var isDashboardView : Bool
    
    override init() {
        self.firstTimeLogin = true
        self.isExerciseListView = false
        self.isDashboardView = false
        self.isFormsView = false
        
        //TODO: refactor realm name
        super.init(realm: "SingleStepAuthRealm")
        //set up the observer. Note: need to append a colon after the selector, since it will have one param
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "readyAppObserverCallback:", name: "viewController", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "readyAppsViewDidDisappearCallback:", name: "disappear", object: nil)
        
    }
    
    /**
    Callback to handle notifications received from registered view controllers. This callback sets the respective boolean flag to false
    once the view has been covered by another view controller.
    - parameter notification:
    */
    func readyAppsViewDidDisappearCallback (notification : NSNotification!) {
        print("in readyAppsViewDidDisappearCallback")
        
        let userInfo:Dictionary<String,Bool!> = notification.userInfo as! Dictionary<String,Bool!>
        
        if (userInfo["ExerciseListViewController"] == false) {
            self.isExerciseListView = false
            
        } else if(userInfo["FormsViewController"] == false) {
            self.isFormsView = false
            
        } else if(userInfo["DashboardViewController"] == false) {
            self.isDashboardView = false
            
        }
        
    }
    
    /**
    Callback to handle notifications received from registered view controllers. This callback sets instance of the view controller, so it can be used 
    to display the login view controller when the user has been logged out
    - parameter notification:
    */
    func readyAppObserverCallback(notification : NSNotification!) {
        
        print("in readyAppObserverCallback")
        
        let userInfo:Dictionary<String,UIViewController!> = notification.userInfo as! Dictionary<String,UIViewController!>
        
        if (userInfo["ExerciseListViewController"] != nil){
            self.exerciseListViewController = userInfo["ExerciseListViewController"] as! ExerciseListViewController
            self.isExerciseListView = true
            
        } else if (userInfo["FormsViewController"] != nil){
            self.formsListViewController = userInfo["FormsViewController"] as! FormsViewController
            self.isFormsView = true
        
        } else if (userInfo["DashboardViewController"] != nil){
            self.dashboardViewController = userInfo["DashboardViewController"] as! DashboardViewController
            self.isDashboardView = true
        
        }

    }
    
    /**
    Callback method for MobileFirst platform authenticator which determines if the user has been timed out.
    - parameter response:
    */
    override func isCustomResponse(response: WLResponse!) -> Bool {
        print("--------- isCustomResponse in readyapps------")
        //check for bad token here
        print(response.getResponseJson())
        if (response != nil && response.getResponseJson() != nil) {
            let jsonResponse = response.getResponseJson() as NSDictionary
            let authRequired = jsonResponse.objectForKey("authRequired") as! Bool?
            if authRequired != nil {
                return authRequired!
            }
        }
        return false
    }
    
    /**
    Callback method for MobileFirst platform which handles the success scenario
    - parameter response:
    */
    override func onSuccess(response: WLResponse!) {
        print("challenge handler on onSuccess")
        print(response)
        submitSuccess(response)
        //if the user is logging on for the first time, process sign in and dismiss the loginview controller
            let dataManager = DataManager.dataManager
        if (firstTimeLogin) {
            dataManager.signIn(self.appDelegate.username, password: self.appDelegate.password, callback: appDelegate.loginViewController.processSignIn)
            firstTimeLogin = false
        } else if (appDelegate.isLogoutSuccess){
            //returning back after logging out. handle this case separately
            SVProgressHUD.dismiss()
            dataManager.signIn(self.appDelegate.username, password: self.appDelegate.password, callback: appDelegate.loginViewController.processSignIn)            
        } else {
            //dismiss the loginviewcontroller and take them back to the screen they were on
            print("coming from different part of app")
            SVProgressHUD.dismiss()
            self.loginViewController.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    /**
    Callback method for MobileFirst platform which handles the failure scenario
    - parameter response:
    */
    override func onFailure(response: WLFailResponse!) {
        print("on ReadyAppsChallengeHandler onFailure");
        submitFailure(response)
        
        print(response)
        
        if(response.getResponseJson() != nil) {
            let jsonResponse = response.getResponseJson() as NSDictionary
            let authRequired = jsonResponse.objectForKey("authRequired") as! Bool?
            if authRequired != nil {
                if authRequired == true {
                    appDelegate.logout("SingleStepAuthRealm")
                }
            }
            // show error message to user
            if (firstTimeLogin) {
                SVProgressHUD.dismiss()
                appDelegate.loginViewController.alertView.hidden = false
                
            } else if (appDelegate.isLogoutSuccess){
                SVProgressHUD.dismiss()
                appDelegate.loginViewController.alertView.hidden = false
                
            } else {
                SVProgressHUD.dismiss()
            
                //logout user and reconnect
                //reconnect if the user is authentication
                //show error on the login page since we are coming from a different part of the app
                print("challenge handler on failure -- coming from different part of the app")
                if let loginVC = loginViewController {
                    loginVC.alertView.hidden = false
                }
            }
        } else {
            SVProgressHUD.dismiss()
            appDelegate.loginViewController.showAlertForServerConnectionFailure()
        }
       
    }
    
    /**
    Callback method for MobileFirst platform which handles challenge presented by the server, It shows the login view controllers, so the user
    can re-authenticate.
    - parameter response:
    */
    override func handleChallenge(response: WLResponse!) {
        if let lvc = appDelegate.loginViewController.navigationController?.visibleViewController as? LoginViewController {
            print("Already showing login view controller");
        } else {
            print("show login view controller")
            SVProgressHUD.dismiss()
            isUserTimedOut = true
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            loginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            if (isExerciseListView){
                
                self.exerciseListViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.exerciseListViewController.presentViewController(loginViewController, animated: true, completion: nil)
                
            } else if (isFormsView){
                
                self.formsListViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.formsListViewController.presentViewController(loginViewController, animated: true, completion: nil)

            } else {
                
                //in video player viewcontroller
                self.dashboardViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.dashboardViewController.presentViewController(loginViewController, animated: true, completion: nil)
                
            }
            
        }
    }
}

