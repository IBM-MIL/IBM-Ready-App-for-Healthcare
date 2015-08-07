/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Enum to keep track of the sidePanel state.
*/
enum SlideOutState {
    case LeftCollapsed
    case LeftExpanded
}

// Static variable to represent space between sidePanel and the centerViewController
let centerPanelExpandedOffset: CGFloat = 100

/**
This viewcontroller is responsible for handling the sidePanelViewController as well as the centerViewController.
It does this by performing animations of the sidePanel and moving the centerViewController accordingly to the right.

*/
class ContainerViewController: UIViewController, CenterViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var originalCenter: CGPoint!
    var menuWidth: CGFloat!
    
    var centerNavigationController: UINavigationController!
    var centerViewController: DashboardViewController!
    var currentState: SlideOutState = .LeftCollapsed {
        // Uses didSet to determine if shadow shows up based on menu state
        didSet {
            // show shadow if left view is expanded
            let shouldShowShadow = currentState != .LeftCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SidePanelViewController?
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        originalCenter = view.center
        menuWidth = view.frame.width - centerPanelExpandedOffset

        centerViewController = UIStoryboard.centerViewController()
        centerViewController.centerViewDelegate = self
        
        // Create navigationController and incorporate within this viewController
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMoveToParentViewController(self)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: CenterViewController delegate methods
    
    /**
    This method adds the left panel and animates the appropriate action
    */
    func toggleLeftPanel() {
        let notExpanded = (currentState != .LeftExpanded)
        
        if notExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notExpanded, delay: false)
    }
    
    /**
    This method instantiates the leftViewController aka the sidePanel
    */
    func addLeftPanelViewController() {
        leftViewController = UIStoryboard.leftViewController()

        addChildSidePanelController(leftViewController!)
    }
    
    /**
    This method adds the sidepanel to the main view as a child
    
    - parameter sidePanelController: The viewController to add as a child
    */
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        //sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        populateSidePanelWithUserData()
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    /**
    Method to determine what type of animation needs to happen
    
    - parameter shouldExpand: A variable to determine if side panel should expand out or not
    */
    func animateLeftPanel(shouldExpand shouldExpand: Bool, delay: Bool) {
        if shouldExpand {
            currentState = .LeftExpanded
            centerViewController.panGestureRecognizer.enabled = false
            centerViewController.webView.userInteractionEnabled = false
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset, shouldDelay: delay)
        } else {
            animateCenterPanelXPosition(targetPosition: 0, shouldDelay: delay) { finished in
                self.currentState = .LeftCollapsed
                self.centerViewController.panGestureRecognizer.enabled = true
                self.centerViewController.webView.userInteractionEnabled = true
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil
                
                // disable pan gesture if metrics tabs are visible on dashboard
                if self.centerViewController.currentState == MetricTabState.TabsVisible {
                    self.togglePanGesture(false)
                }
            }
        }
    }
    
    /**
    Method that performs the horizontal side menu animation
    
    - parameter targetPosition: The ending x value for centerNavigationController frame
    - parameter completion: An optional completion closure
    */
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, shouldDelay: Bool, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.45, delay: (shouldDelay ? 0.15 : 0), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    /**
    Method to add shadow opacity to centerNavigationController
    
    - parameter shouldShowShadow: This variable determines to add a shadow or remove a shadow
    */
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    /**
    Method that determines if side panel is expanded and centerViewController should allow user interaction
    
    - returns: Bool Method returns value to determine if centerViewController interaction should be disabled
    */
    func isSidePanelExpanded() -> Bool {
        if currentState == .LeftExpanded {
            return true
        }
        return false
    }
    
    /**
    Method to enable or disable panning gesture for sidePanel
    
    - parameter enable: value to assign to panning gesture's enabled property
    */
    func togglePanGesture(enable: Bool) {
        panGestureRecognizer.enabled = enable
    }
    
    // MARK: Gesture recognizer
    
    /**
    Method that recognizes the sidePanel panning gesture and moves the views accordingly.
    
    - parameter recognizer: the centerNavigationController is the view being panned
    */
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDragging = (recognizer.velocityInView(view).x > 0)
        
        // We don't want 2 pans happening at the exact same time
        if centerViewController.isDragging {
            return
        }
        
        switch (recognizer.state) {
            // create leftpanel if it is collapsed
            case .Began:
                
                if (currentState == .LeftCollapsed) {
                    if (gestureIsDragging) {
                        addLeftPanelViewController()
                    }
                    showShadowForCenterViewController(true)
                }
            
            // only translate view if pan gesture is going left to right
            case .Changed:
                
                let newCenterX = recognizer.view!.center.x + recognizer.translationInView(view).x
                // only move centerViewController if less than menu width from center and greater than originalCenter
                if (newCenterX < (originalCenter.x + menuWidth) && newCenterX > originalCenter.x) {
                    recognizer.view!.center.x = newCenterX
                    recognizer.setTranslation(CGPointZero, inView: view)
                }
            
            // finish open or close if pan ended past halfway
            case .Ended:
                
                if (leftViewController != nil) {
                    let movedPastHalf = recognizer.view!.center.x > view.bounds.size.width - 50
                    animateLeftPanel(shouldExpand: movedPastHalf, delay: false)
                }
            
            default:
                break
        }
    }

    /**
    Method to recognize tap on centerViewController and close sidePanel if it is open.
    
    - parameter recognizer: recognizer added the centerViewController
    */
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        if currentState == .LeftExpanded {
            toggleLeftPanel()
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /**
    This method populates the sidePanel with data about the patient received from the server.
    */
    func populateSidePanelWithUserData() {
        var thePatient =  DataManager.dataManager.currentPatient
        leftViewController!.userIDLabel.text = "\(thePatient.userID)"
        var components = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: thePatient.dateOfNextVisit)
        
        // creates a localized month/day formatted string
        var localizedDate = NSDateFormatter.localizedStringFromDate(thePatient.dateOfNextVisit, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        var pieces = localizedDate.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == "/"}).map { String($0) }
        if pieces.count >= 2 {
            leftViewController!.dateLabel.text = "\(pieces.first!)/\(pieces[1])"
        }
        var middleString = NSLocalizedString("of", comment: "n/a")
        leftViewController!.weekLabel.text = "\(thePatient.visitsUsed) \(middleString) \(thePatient.visitsTotal)"

    }
    
    /**
    Method to swap out root view controllers for the conatiner
    
    - parameter centerVC: view controller to set as root
    */
    func updateCenterViewController(centerVC: UIViewController) {
        
        var newViewController: UIViewController = centerVC
        
        // Set the already created dashboardViewController to avoid duplicating code
        if newViewController.isKindOfClass(DashboardViewController.self) {
            newViewController = self.centerViewController
        }
        
        // If we are on the Pain Location View Controller and we are pushing the same view controller, dont do it! Causes a bug.
        if newViewController.isKindOfClass(PainLocationViewController.self) && self.centerNavigationController.viewControllers[0].isKindOfClass(PainLocationViewController.self) {
            self.animateLeftPanel(shouldExpand: false, delay: false)
        } else {
            self.centerNavigationController.viewControllers.removeAtIndex(0)
            self.centerNavigationController.pushViewController(newViewController, animated: false)
            
            self.animateLeftPanel(shouldExpand: false, delay: true)
        }

    }
    
    /**
    Method to swap out the root view controller with the dashboard and the pop to the root
    */
    func popAndReturnHome() {
        
        var temp: [AnyObject] = [self.centerViewController]
        swap(&self.centerNavigationController.viewControllers[0], &temp[0])
        self.centerNavigationController.navigationBar.translucent = true
        self.centerNavigationController.popToRootViewControllerAnimated(true)
        
    }

}

/**
Helper extension for simplier creation of Storyboard view controllers
*/
extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> DashboardViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? DashboardViewController
    }
    
    class func progressViewController() -> ProgressViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ProgressViewController") as? ProgressViewController
    }
    
    class func painRatingViewController() -> PainRatingViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("PainRatingViewController") as? PainRatingViewController
    }
    
    class func painLocationViewController() -> PainLocationViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("PainLocationViewController") as? PainLocationViewController
    }
    
    class func formsViewController() -> FormsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("FormsViewController") as? FormsViewController
    }
    
    class func exerciseListViewController() -> ExerciseListViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ExerciseListViewController") as? ExerciseListViewController
    }
    
    class func loginViewController() -> LoginViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
    }
    
    class func videoPlayerViewController() -> VideoPlayerViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("VideoPlayerViewController") as? VideoPlayerViewController
    }
}