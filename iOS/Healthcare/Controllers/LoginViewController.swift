/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
This view controller handles all the login logic and user interaction.
This includes authentication with the server and moving the view up when the keyboard appears.
*/
class LoginViewController: UIViewController, UITextFieldDelegate, CustomAlertViewExerciseDelegate {


    @IBOutlet weak var patientIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var alertView: CustomAlertViewExercise!
    var timeOutTimer: NSTimer!
    var haveLoginResult = false
    var appDelegate : AppDelegate!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Alter placeholder text color
        if (patientIDTextField.respondsToSelector("setAttributedPlaceholder:")) {
            patientIDTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Patient ID", comment: "n/a"), attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "n/a"), attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
        // add observers for keyboard events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Setup the alert view that will be displayed if the Login fails
        let alertText = NSLocalizedString("Login Failed.", comment: "")
        let buttonText = NSLocalizedString("Try another ID or Password", comment: "")
        let showSublabel = false
        self.alertView = CustomAlertViewExercise.initWithText(alertText, showSublabel: showSublabel, buttonText: buttonText)
        self.alertView.imageView.image = UIImage(named: "x_red")
        self.alertView.nextButton.backgroundColor = UIColor.readyAppRed()
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        self.alertView.delegate = self
        self.alertView.hidden = true
        self.view.addSubview(alertView)
        self.setupAlertViewConstraints()

        let userInfo:Dictionary<String,UIViewController!> = ["LoginViewController" : self]
        NSNotificationCenter.defaultCenter().postNotificationName("loginVCKey", object: nil, userInfo: userInfo)

    }
    
    /**
    Handles memory warnings
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Setups the the custom alert view to fill the entire view
    */
    func setupAlertViewConstraints() {
        var viewsDict = Dictionary<String, UIView>()
        
        viewsDict["alertView"] = self.alertView
        viewsDict["view"] = self.view
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
    }
    
    /**
    Called when the button is pressed on the alert view
    */
    func handleNextButtonPressed() {
        self.alertView.hidden = true
    }

    // MARK: Log in methods
    
    /**
    This method authenticates user and loads the dashboard
    
    - parameter sender: The UIButton calling this action
    */
    @IBAction func loginUser(sender: AnyObject) {
        // dismiss keyboard to ensure invalid text is hidden on future attempts
        patientIDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if let patientText = patientIDTextField.text, passwordText = passwordTextField.text {
            
            // sign in with credentials in text fields
            if (patientText.isEmpty || passwordText.isEmpty) {
                self.alertView.hidden = false
            }
            else {
                SVProgressHUD.show()
                let language : String = (NSLocale.currentLocale().localeIdentifier)
                appDelegate.submitAuthentication(patientIDTextField.text!, password: passwordTextField.text!, locale: language)
            }
            
        }

    }
    
    /**
    Notifies the user about server connection failure.
    */
    func showAlertForServerConnectionFailure(){
        self.alertView.hidden = false
        self.alertView.labelMain.text = "Could not connect to server"
        self.alertView.nextButton.setTitle("Please try again later.", forState: UIControlState.Normal)
    }

    /**
    Login callback method that is run after authentication check
    
    - parameter result: the result of authentication
    */
    func processSignIn(result: LogInResultType) {
        
        haveLoginResult = true
        dispatch_async(dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
        if (result == LogInResultType.Success) {
            // If User2 and Password2 are the login values, then load the fake HealthKit data
            if (appDelegate.username == "user2" && appDelegate.password == "password2") {
                let didAlreadyPopulateHealthKit = NSUserDefaults.standardUserDefaults().boolForKey("healthkit_populated")
                
                if !didAlreadyPopulateHealthKit {
                    let alert = UIAlertController(title: NSLocalizedString("Populate HealthKit", comment: "n/a"), message: NSLocalizedString("You are about to load a significant amount of Heart Rate, Calories Burned, Body Weight, and Steps data into your HealthKit.  To remove this data from your HealthKit, log out from the menu, or delete the app from your phone.", comment: "n/a"), preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default) { (action) in
                        
                        // If okay, show HUD again, get permissions (which will call the function to load the data)
                        SVProgressHUD.showWithStatus(NSLocalizedString("Populating HealthKit...", comment: "n/a"))
                        HealthKitManager.healthKitManager.shouldPopulateHealthKit = true;
                        HealthKitManager.healthKitManager.getPermissionsForHealthKit(self.progressToDashboard)
                        
                        // Mark that we have loaded HealthKit data so that we don't do it twice
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "healthkit_populated")
                    }
                    
                    alert.addAction(OKAction)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "n/a"), style: .Default) { (action) in
                        
                        // If cancel, then just get the permissions
                        HealthKitManager.healthKitManager.getPermissionsForHealthKit(self.progressToDashboard)
                    }
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("HealthKit Already Populated", comment: "n/a"), message: NSLocalizedString("You have already populated your HealthKit with data.  To remove this data from your phone, either Log Out or delete the app from your phone.", comment: "n/a"), preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default) { (action) in
                        HealthKitManager.healthKitManager.getPermissionsForHealthKit(self.progressToDashboard)
                    }
                    
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
            else {
                HealthKitManager.healthKitManager.getPermissionsForHealthKit(progressToDashboard)
            }
        } else {

            if(result == LogInResultType.FailWrongPassword){
                
            }
            if(result == LogInResultType.FailWrongUserID){
                
            }
            self.alertView.hidden = false

        }
        
    }
    
    /**
    Method to get called after 30 seconds with no authentication results from the server, alerts user of issue
    */
    func timeOutDone() {
        if !haveLoginResult {
            dispatch_async(dispatch_get_main_queue()) {
                SVProgressHUD.dismiss()
            }
            timeOutTimer.invalidate()
            
            let alert = UIAlertController(title: NSLocalizedString("Cannot communicate with the server", comment: "n/a"), message: NSLocalizedString("Please try again later", comment: "n/a"), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
    Method to present dashboardViewController if HealthKit permission has been allowed.
    
    - parameter shouldProgress: Bool that determines if HealthKit access was granted.
    */
    func progressToDashboard(shouldProgress: Bool) {
        if (shouldProgress) {
            dispatch_async(dispatch_get_main_queue()) {
                SVProgressHUD.dismiss()
            }
            // Must present view controller on main thread to avoid issues
            dispatch_async(dispatch_get_main_queue(), {
                let containerViewController = ContainerViewController()
                containerViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.presentViewController(containerViewController, animated: true, completion: nil)
            })
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Please Allow HealthKit Access", comment: "n/a"), message: NSLocalizedString("You must allow access to HealthKit to properly use Physio", comment: "n/a"), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
    This method defines what should happen when the return key is pressed
    
    - parameter textField: The textfield that is selected at the time the return key is pressed
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == patientIDTextField){
            passwordTextField.becomeFirstResponder()
        }
        if(textField == passwordTextField){
            passwordTextField.resignFirstResponder()
            loginUser(passwordTextField)
        }
        return true;
    }
    
    //MARK: Keyboard notification methods
    
    /**
    Method that detects keyboard becoming active and the view's frame is pushed up accordingly.
    
    - parameter notification: notification that keyboard has become active
    */
    func keyboardWillShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let kbFrame = (info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval

        UIView.animateWithDuration(duration, animations: ({
            self.view.frame = CGRectOffset(self.view.frame, 0, -kbFrame.size.height)
            self.view.layoutIfNeeded()
        }))
    }
    
    /**
    Method that detects keyboard dismissing and view's frame returning to the default position.
    
    - parameter notification: notificaiton that the keyboard is dismissing
    */
    func keyboardWillHide(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let kbFrame = (info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        
        UIView.animateWithDuration(duration, animations: ({
            self.view.frame = CGRectOffset(self.view.frame, 0, kbFrame.size.height)
            self.view.layoutIfNeeded()
        }))
    }
}
