/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import CoreData

/**
This is the last viewController in the pain management flow, used to give a numerical rating and description of pain.
*/
class PainRatingViewController: UIViewController,UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CustomAlertViewDelegate, CustomAlertViewButtonsDelegate {
    
    var NUM_CONTROLLERS_IN_PAIN_FLOW = 2    //used to for navigation after pain report is submitted
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var minNumLabel: UILabel!
    @IBOutlet weak var maxNumLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    var alertViewSimple: CustomAlertView!
    var alertViewButtons: CustomAlertViewButtons!
    var simpleAlertLeftConstraint: NSArray!
    var buttonAlertLeftConstraint: NSArray!
    
    var themeColor: UIColor = UIColor.readyAppRed()
    var bottomButtonColor: UIColor = UIColor.readyAppBlack()
    
    var placeHolder = NSLocalizedString("Add a description of your pain.", comment: "n/a")
    var originalCenter: CGPoint!
    
    var useBlueColor: Bool = false
    @IBOutlet weak var milCollectionView: MILRatingCollectionView!
    
    /// lazy loading access to the managedObjectContext for the app, originally created in AppDelegate
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.rootViewMenu(self.parentViewController!, disablePanning: true)
        
        // Setup the alert view that will be displayed when the user Submits the pain report
        var alertText = NSLocalizedString("Are you sure you want to submit this Pain Report?", comment: "")
        var alertColor = UIColor.readyAppRed()
        if self.useBlueColor {
            alertText = NSLocalizedString("Are you sure you want to submit this Form?", comment: "")
            alertColor = UIColor.readyAppBlue()
        }
        alertViewButtons = CustomAlertViewButtons.initWithButtonColor(alertColor, alertText: alertText)
        alertViewButtons.setTranslatesAutoresizingMaskIntoConstraints(false)
        alertViewButtons.delegate = self
        alertViewButtons.hidden = true
        self.view.addSubview(alertViewButtons)
        
        // Setup the alert that is displayed when the Form/Pain report is submitted
        alertText = NSLocalizedString("Pain Report submitted", comment: "")
        var alertImageName = "checkmark_red"
        if self.useBlueColor {
            alertText = NSLocalizedString("Form submitted", comment: "")
            alertImageName = "checkmark_blue"
        }
        alertViewSimple = CustomAlertView.initWithText(alertText, imageName: alertImageName)
        alertViewSimple.setTranslatesAutoresizingMaskIntoConstraints(false)
        alertViewSimple.delegate = self
        alertViewSimple.hidden = true
        self.view.addSubview(alertViewSimple)
        self.setupAlertViewConstraints()
        
        // Number picker collectionView set up
        if self.useBlueColor {
            milCollectionView.circularView.backgroundColor = UIColor.readyAppBlue()
        } else {
            milCollectionView.circularView.backgroundColor = themeColor
        }
        milCollectionView.numberRange = NSMakeRange(0, 11)
        minNumLabel.text = "\(milCollectionView.numberRange.location)"
        maxNumLabel.text = milCollectionView.numberRange.location == 0 ? "\(milCollectionView.numberRange.length - 1)" : "\(milCollectionView.numberRange.length + milCollectionView.numberRange.location - 1)"
        
        // set theme colors
        if self.useBlueColor {
            topView.backgroundColor = UIColor.readyAppBlue()
        } else {
            topView.backgroundColor = themeColor
        }
        bottomButton.backgroundColor = bottomButtonColor

        // add observers for keyboard events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        originalCenter = self.view.center
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "textViewTapped")
        self.descriptionTextView.addGestureRecognizer(tapGesture)
        self.descriptionTextView.text = placeHolder
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the starting position for the collectionView before view is visible
        self.milCollectionView.scrollToItemAtIndexPath(milCollectionView.selectedIndexPath!, atScrollPosition: .CenteredHorizontally, animated: false)
    }
    
    /**
    Setups the the custom alert view to fill the entire view
    */
    func setupAlertViewConstraints() {
        var viewsDict = Dictionary<String, UIView>()
        var metricsDict = ["simpleOffsetLeft": self.view.frame.size.width, "simpleOffsetRight": -self.view.frame.size.width]
        viewsDict["alertViewSimple"] = self.alertViewSimple
        viewsDict["alertViewButtons"] = self.alertViewButtons
        viewsDict["view"] = self.view
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertViewSimple]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertViewButtons]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        
        self.simpleAlertLeftConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-simpleOffsetLeft-[alertViewSimple]-simpleOffsetRight-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: metricsDict, views: viewsDict)
        self.buttonAlertLeftConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[alertViewButtons]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict)
        self.view.addConstraints(self.simpleAlertLeftConstraint as! [NSLayoutConstraint])
        self.view.addConstraints(self.buttonAlertLeftConstraint as! [NSLayoutConstraint])
    }
    
    func shiftAlertViews() {
        self.view.removeConstraints(self.simpleAlertLeftConstraint as! [NSLayoutConstraint])
        self.view.removeConstraints(self.buttonAlertLeftConstraint as! [NSLayoutConstraint])
        
        var viewsDict = Dictionary<String, UIView>()
        var metricsDict = ["buttonOffsetLeft": -self.view.frame.size.width, "buttonOffsetRight": self.view.frame.size.width]
        viewsDict["alertViewSimple"] = self.alertViewSimple
        viewsDict["alertViewButtons"] = self.alertViewButtons
        viewsDict["view"] = self.view
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertViewSimple]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertViewButtons]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        
        self.simpleAlertLeftConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[alertViewSimple]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: metricsDict, views: viewsDict)
        self.buttonAlertLeftConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-buttonOffsetLeft-[alertViewButtons]-buttonOffsetRight-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: metricsDict, views: viewsDict)
        self.view.addConstraints(self.simpleAlertLeftConstraint as! [NSLayoutConstraint])
        self.view.addConstraints(self.buttonAlertLeftConstraint as! [NSLayoutConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func popViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Method to open the side panel
    */
    func openSideMenu() {
        var container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
    }
    
    // MARK: Custom Alert View Delegate Methods
    
    func handleAlertTap() {
        // Do nothing
    }
    
    /**
    Called when Yes button is pressed on the alert view. Saves data, shows a confirmation alert, then pops to the root controller.
    */
    func handleAlertYesTap() {
        self.alertViewSimple.hidden = false
        self.shiftAlertViews()
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: { done in
            self.alertViewButtons.hidden = true
        })
        var painRating: Int = self.milCollectionView.selectedIndexPath!.row
        var painDescription = self.descriptionTextView.text == placeHolder ? "" : self.descriptionTextView.text
        PainData.createInManagedObjectContext(self.managedObjectContext!, rating: painRating, description: painDescription)
        PainData.saveData(self.managedObjectContext!)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("navigateToRoot"), userInfo: nil, repeats: false)
    }
    
    /**
    This function navigates back to the screen from which we entered the Pain Report flow.  If we are in the forms flow then 
    navigate to the dashbaord.  If the number of view controllers in the navigation stack is equal to the number of view 
    controllers in the Pain Report flow, then we entered the flow from the Side Menu and we will navigate back to the Dashboard. 
    Otherwise we will pop back to the entering view controller.
    */
    func navigateToRoot() {
        var numViewControllers = self.navigationController?.viewControllers.count
 
        if self.useBlueColor {
            Utils.returnToDashboard()
        } else {
            if numViewControllers == NUM_CONTROLLERS_IN_PAIN_FLOW {
                Utils.returnToDashboard()
            } else if numViewControllers > NUM_CONTROLLERS_IN_PAIN_FLOW {
                var indexToPopTo = numViewControllers! - NUM_CONTROLLERS_IN_PAIN_FLOW - 1
                var vc: UIViewController = self.navigationController?.viewControllers[indexToPopTo] as! UIViewController
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    /**
    Called when No button is pressed on the alert view and hides the alert
    */
    func handleAlertNoTap() {
        self.alertViewButtons.hidden = true
    }
    
    //MARK: Keyboard notification methods
    // Keyboard methods are implemented so that the textView remains visible when keyboard is present
    
    func keyboardWillShow(notification: NSNotification) {
        var info : NSDictionary = notification.userInfo!
        var kbFrame = (info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        var duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        
        UIView.animateWithDuration(duration, animations: ({
            self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - kbFrame.height)
            self.view.layoutIfNeeded()
        }))
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info : NSDictionary = notification.userInfo!
        var kbFrame = (info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        var duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        
        UIView.animateWithDuration(duration, animations: ({
            self.view.center = self.originalCenter
            self.view.layoutIfNeeded()
        }))
    }
    
    // MARK: UITextView delegate methods
    
    /**
    TextView delegate method to recognize a done key press and then dismiss the keyboard if so.
    
    :param: textView The text view containing the changes
    :param: range    The current selection range
    :param: text     The text to insert
    
    :returns: true if editing should continue, false if not.
    */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /**
    Forces descriptionTextView to become active for delegate methods to work properly
    */
    func textViewTapped() {
        self.descriptionTextView.becomeFirstResponder()
    }
    
    /**
    If placeholder is the only text, put cursor at front of textView
    
    :param: textView callback activated for this textView
    */
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeHolder {
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    /**
    Essentially creates the placeholder functionality in UITextView
    
    :param: textView callback activated for this textView
    */
    func textViewDidChange(textView: UITextView) {
        var placeholder = placeHolder as NSString
        if (textView.text as NSString).length > placeholder.length{
            
            var substring : String = (textView.text as NSString).substringFromIndex(1)
            if substring == placeholder {
                textView.text = (textView.text as NSString).substringToIndex(1)
                textView.textColor = UIColor(red: 78/255.0, green: 77/255.0, blue: 73/255.0, alpha: 1.0)
            }
            
        } else if textView.text == "" {
            textView.text = placeholder as String
            textView.textColor = UIColor(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 1.0)
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }

    // MARK: Optional CollectionView delegate and datasource
    // relevant code is in parent CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    // Set preDelegate and preDataSource to have this method called, add extra customization in here, for example: cell.backgroundColor = UIColor.yellowColor()
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.milCollectionView.ratingCellID, forIndexPath: indexPath) as! RatingCollectionViewCell

        return cell
    }
    
    /**
    Called when submit button is pressed and displays an alert to confirm the users choice
    
    :param: sender button calling this method
    */
    @IBAction func submitPain(sender: AnyObject) {
        self.alertViewButtons.hidden = false
        descriptionTextView.resignFirstResponder()
    }

}
