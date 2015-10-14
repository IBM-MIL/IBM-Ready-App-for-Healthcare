/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import QuartzCore

/**
Protocol to interact with sidePanel.
@objc flag allows optional delegate methods
*/
@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func isSidePanelExpanded() -> Bool
    optional func togglePanGesture(enable: Bool)
}

/**
Enum to keep track of the metric tabs state.
*/
enum MetricTabState {
    case TabsHidden
    case TabsVisible
}

/**
This viewController displays a hybrid view will various types of data.
The user can also access the sidePanel from here as well as the metric tab components.

*/
class DashboardViewController: MILWebViewController, UIGestureRecognizerDelegate, MILWebViewDelegate {
    
    var centerViewDelegate: CenterViewControllerDelegate!
    var viewsDictionary = Dictionary <String, UIView>()
    var availableTabs = [UIView]()
    var availableTabStrings = [String]()
    var routeExtension = [String]()
    
    var firstTabConstraint: NSLayoutConstraint!
    var secondTabConstraint: NSLayoutConstraint!
    var thirdTabConstraint: NSLayoutConstraint!
    var initialTabWidth: CGFloat = 108
    var firstLeadingConstant: CGFloat = 0
    var secondLeadingConstant: CGFloat = 0
    var thirdLeadingConstant: CGFloat = 0
    
    var baselineValue: CGFloat = 0
    var currentState: MetricTabState = .TabsVisible
    var panGestureRecognizer: UIPanGestureRecognizer!
    var isDragging: Bool = false
    
    @IBOutlet weak var heartTab: UIView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var heartRateTitle: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var minHeartLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxHeartLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var weightTab: UIView!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var weightImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var poundsLabel: UILabel!
    @IBOutlet weak var poundsLostLabel: UILabel!
    @IBOutlet weak var thisWeekLabel: UILabel!
    
    @IBOutlet weak var stepsTab: UIView!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepsImageView: UIImageView!
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var firstGoalLabel: UILabel!
    @IBOutlet weak var goalNumberLabel: UILabel!
    @IBOutlet weak var secondGoalLabel: UILabel!
    
    @IBOutlet weak var caloriesTab: UIView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesGoalLabel: UILabel!
    @IBOutlet weak var largeCalorieUnitLabel: UILabel!
    @IBOutlet weak var smallCalorieUnitLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        self.startPage = "index.html/WebView/dashboard"
        
        super.viewDidLoad()
        self.webView.scrollView.scrollEnabled = false
        self.delegate = self
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        

        if let font = UIFont(name: "RobotoSlab-Bold", size: 18) {
            let textFontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName : UIColor.whiteColor()]
            self.navigationController?.navigationBar.titleTextAttributes = textFontAttributes
        }

        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        // disable pan gesture until initial animation is complete
        panGestureRecognizer.enabled = false
        
        setupAutoLayoutConstraints()
        populateTabsWithData()
        self.addTapGesturesToTabs()

        firstLeadingConstant = self.view.frame.size.width
        secondLeadingConstant = self.view.frame.size.width
        thirdLeadingConstant = self.view.frame.size.width
        
        // dismiss metrics tab after initial startup
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "initialTabAnimation", userInfo: nil, repeats: false)
        
        //send notification to challenge handler
        let userInfo:Dictionary<String,UIViewController!> = ["DashboardViewController" : self]
        NSNotificationCenter.defaultCenter().postNotificationName("viewController", object: nil, userInfo: userInfo)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // ensure route is correct so get started button will work every time
        let reload = Utils.prepareCodeInjectionString("switchRoute('/WebView/dashboard', false)")
        self.webView.stringByEvaluatingJavaScriptFromString(reload)

        
        // Give it a delay so webView will settle
        dispatch_after( dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(0.2 * Double(NSEC_PER_SEC))
            ), dispatch_get_main_queue(), {
                let localeLoad = Utils.prepareCodeInjectionString("setLanguage('\(NSLocale.currentLocale().localeIdentifier)')")
                self.webView.stringByEvaluatingJavaScriptFromString(localeLoad)
                self.updateHybridView()
        })
        
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.translucent = true
        // ensures sidePanel is accessible when on dashboard
        if let del = centerViewDelegate {
            del.togglePanGesture?(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Notifies the ReadyAppsChallengeHandler that another view controller has been placed on top of the dashboard
    */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let userInfo:Dictionary<String,Bool!> = ["DashboardViewController" : false]
        NSNotificationCenter.defaultCenter().postNotificationName("disappear", object: nil, userInfo: userInfo)
    }
    
    /**
    This method updates the webview with the data received from the server
    The date is calculated locally for the user
    */
    func updateHybridView() {
        // retrieve and format date
        let currentDate = NSDate()
        var formattedDate = ""

        // Currently only support ordinal number endings for english dates
        if NSLocale.currentLocale().localeIdentifier == "en_US" || NSLocale.currentLocale().localeIdentifier == "en" {
            let month: String = Utils.extractMonthNameFromDate(currentDate)
            let day: Int = Utils.extractDayFromDate(currentDate)
            formattedDate = "\(month) \(Utils.daySuffixFromDay(day))"
        } else {
            formattedDate = Utils.localizedMonthDay(currentDate, dateStyle: NSDateFormatterStyle.LongStyle)
        }
        
        // format and send data to the hybrid view
        let dateUpdate = Utils.prepareCodeInjectionString("setDate('\(formattedDate)')")
        let minuteUpdate = Utils.prepareCodeInjectionString("setMinutes('\(Utils.formatSingleDigits(45))')")
        let exerciseUpdate = Utils.prepareCodeInjectionString("setExercises('\(Utils.formatSingleDigits(22))')")
        let sessionUpdate = Utils.prepareCodeInjectionString("setSessions('\(Utils.formatSingleDigits(2))')")
        self.webView.stringByEvaluatingJavaScriptFromString(dateUpdate + minuteUpdate + exerciseUpdate + sessionUpdate)
    }
    
    // MARK: Metric tab animation methods
    
    /**
    Method to animate tabs off screen in delayed sequence, only used after viewDidLoad
    */
    func initialTabAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.thirdTabConstraint.constant = self.firstLeadingConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.1, options: [], animations: {
            self.secondTabConstraint.constant = self.secondLeadingConstant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.2, options: [], animations: {
            self.firstTabConstraint.constant = self.thirdLeadingConstant
            self.view.layoutIfNeeded()
            }, completion: { (done: Bool) in
            self.panGestureRecognizer.enabled = true
            
        })
        
        self.currentState = .TabsHidden
    }
    
    /**
    This method animates the metric tabs leading edge constraints to the desired state.
    */
    func animatedTabTranslation() {
        
        firstTabConstraint.constant = thirdLeadingConstant
        secondTabConstraint.constant = secondLeadingConstant
        thirdTabConstraint.constant = firstLeadingConstant
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
            
            // if tabs are hidden set correct states and enable sidePanel pan gesture
            if self.thirdLeadingConstant >= self.view.frame.size.width {
                self.currentState = .TabsHidden
                if let del = self.centerViewDelegate {
                    del.togglePanGesture!(true)
                }
                
            }
                // if tabs are visible set correct states and disable sidePanel pan gesture
            else {
                self.currentState = .TabsVisible
                if let del = self.centerViewDelegate {
                    del.togglePanGesture!(false)
                }
            }
            
            }, completion:nil)
    }
    
    /**
    This method makes an immediate translation of the metric tabs leading edge constraints, useful with the panning gesture
    */
    func immediateTabTranslation() {
        firstTabConstraint.constant = thirdLeadingConstant
        secondTabConstraint.constant = secondLeadingConstant
        thirdTabConstraint.constant = firstLeadingConstant
        self.view.layoutIfNeeded()
    }
    
    // MARK: UIGestureRecognizer delegate methods and callbacks
    
    /**
    Method to determine if tab x value is in specified range
    
    - parameter value: current tab x value to test
    
    - returns: true if in specified range
    */
    func inTabRange(value: CGFloat) -> Bool {
        return (value >= (self.view.frame.size.width - initialTabWidth) && (value <= self.view.frame.size.width))
    }
    
    /**
    This method determines the leading edge constraint for the 3 different tabs.
    Ensures smooth panning with each tab offset by 30 from eachother.
    
    - parameter xValue:      potential leading edge value if in range
    - parameter panningLeft: bool to represent if user is panning left
    */
    func determineTabPlacement(xValue: CGFloat, panningLeft: Bool) {
        let middleTabOffset: CGFloat = 30
        let topTabOffset: CGFloat = middleTabOffset * 2
        
        // The other constants are offset from the firstLeadingConstant
        if inTabRange(xValue) {
            firstLeadingConstant = xValue
        }

        // if user is panning left...
        // And leadingEdge value plus offset is still in the specified range...
        // And determines if constraint constant offset enough to the right before it starts moving with bottom tab.
        if (panningLeft) && inTabRange(xValue + middleTabOffset) && secondLeadingConstant > xValue + middleTabOffset {
            secondLeadingConstant = xValue + middleTabOffset
        } else if (!panningLeft) && inTabRange(xValue - middleTabOffset) && secondLeadingConstant < xValue - middleTabOffset {
            secondLeadingConstant = xValue - middleTabOffset
        }
        
        if (panningLeft) && inTabRange(xValue + topTabOffset) && thirdLeadingConstant > xValue + topTabOffset {
            thirdLeadingConstant = xValue + topTabOffset
        } else if (!panningLeft) && inTabRange(xValue - topTabOffset) && thirdLeadingConstant < xValue - topTabOffset {
            thirdLeadingConstant = xValue - topTabOffset
        }
        immediateTabTranslation()
    }
    
    /**
    Method to control movement of metric tabs on and off screen with a panning gesture
    
    - parameter recognizer: the recognizer added to the dashboard
    */
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        // prevents metric tabs movement when sidePanel is expanded
        if let del = centerViewDelegate {
            if del.isSidePanelExpanded!() {
                // ensures sidePanel pan gesture is enabled
                del.togglePanGesture!(true)
                return
            }
        }
        
        // if this panning happens, we assume the user is trying to open the sidePanel
        if thirdLeadingConstant >= self.view.frame.size.width && recognizer.velocityInView(view).x > 0 {
            return
        }
        
        switch (recognizer.state) {
            // .Began sets a baseline in order to know where to move metric tabs
        case .Began:
            
            isDragging = true
            baselineValue = currentState == .TabsHidden ? self.view.frame.size.width : self.view.frame.size.width - initialTabWidth
            
            // .Changed evaluates if tempValue is in the valid range set up for the metric tabs
        case .Changed:
            
            let tempValue = baselineValue + recognizer.translationInView(view).x
            determineTabPlacement(tempValue, panningLeft: recognizer.velocityInView(view).x < 0 ? true : false)

            // .Ended finishes metric tab animation to a visible or hidden state
        case .Ended:
            
            isDragging = false
            let halfOfRange = self.view.frame.size.width - (initialTabWidth/2)
            
            if (firstLeadingConstant > halfOfRange) {
                // animate metric tabs to hidden state
                firstLeadingConstant = self.view.frame.size.width
                secondLeadingConstant = self.view.frame.size.width
                thirdLeadingConstant = self.view.frame.size.width
                animatedTabTranslation()
            } else {
                // animate metric tabs to visible state
                firstLeadingConstant = self.view.frame.size.width - initialTabWidth
                secondLeadingConstant = self.view.frame.size.width - initialTabWidth
                thirdLeadingConstant = self.view.frame.size.width - initialTabWidth
                animatedTabTranslation()
            }
            
        default:
            break
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: SideMenu related methods
    
    /**
    Method to call delegate menu to toggle left side panel
    
    - parameter sender: The UIButton calling this action
    */
    @IBAction func openSideMenu(sender: AnyObject) {
        if let del = centerViewDelegate {
            del.togglePanGesture?(true)
            del.toggleLeftPanel?()
        }
    }
    
    // MARK: Metric tab layout and data population
    
    /**
    This method populates the metrics tab with data retrieved from HealthKit and goals retrieved from the server
    */
    func populateTabsWithData() {

        var startDate = NSDate()
        startDate = startDate.dateTwoWeeksAgo()   //Get data for the past 7 days
        let format = ".0"
        
        // retrieve data and update UI on main thread for immediate change
        HealthKitManager.healthKitManager.getSteps(startDate, callback: { (steps, error) in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), {
                    self.stepCountLabel.text = "\(steps.format(format))"
                })
            }
        })
        
        HealthKitManager.healthKitManager.getHeartRateData(startDate, callback: { (data, err) in
            if err == nil {
                if data != nil{
                    dispatch_async(dispatch_get_main_queue(), {
                        if let val = data[HeartRateData.Average.rawValue] {
                            self.heartLabel.text = "\(val.format(format))"
                        }
                        if let val = data[HeartRateData.Min.rawValue] {
                            self.minHeartLabel.text = "\(val.format(format))"
                        }
                        if let val = data[HeartRateData.Max.rawValue] {
                            self.maxHeartLabel.text = "\(val.format(format))"
                        }
                    })
                }
            }
        })
        
        HealthKitManager.healthKitManager.getWeightInPoundsData(startDate, callback: { (data, err) in
            if err == nil {
                if data != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let val = data[WeightInPoundsData.Current.rawValue] {
                            self.weightLabel.text = Utils.getLocalizedWeight(val)
                            self.poundsLabel.text = Utils.getLocalizedWeightUnit(val)
    
                            if let change = data[WeightInPoundsData.Start.rawValue] {
                                let weightLost = val - change
                                self.poundsLostLabel.text = Utils.getLocalizedWeight(weightLost)
                                if (weightLost > 0) {
                                    let progressText = NSLocalizedString(" gained this week.", comment: "n/a")
                                    self.thisWeekLabel.text = Utils.getLocalizedWeightUnit(val) + progressText
                                } else {
                                    let progressText = NSLocalizedString(" lost this week.", comment: "n/a")
                                    self.thisWeekLabel.text = Utils.getLocalizedWeightUnit(val) + progressText
                                }
                            }
                        }

                    })
                }
            }
        })
        
        HealthKitManager.healthKitManager.getCaloriesBurned(startDate, callback: { (calories, error) in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), {
                    self.caloriesLabel.text = Utils.getLocalizedEnergy(calories)
                    self.largeCalorieUnitLabel.text = Utils.getLocalizedEnergyUnit(calories)
                })
            }
        })
        
       self.goalNumberLabel.text = "\(DataManager.dataManager.currentPatient.stepGoal)"
       self.caloriesGoalLabel.text = "\(DataManager.dataManager.currentPatient.calorieGoal)"
    }
    
    // MARK: Navigation prep and actions
    
    /**
    Method to add UITapGestures on each visible metric tabs
    */
    func addTapGesturesToTabs() {
        for index in 0...2 {
            let tap = UITapGestureRecognizer(target: self, action: "openProgressView:")
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            self.availableTabs[index].addGestureRecognizer(tap)
            // Ensure tabs are above webview
            self.view.bringSubviewToFront(self.availableTabs[index])
        }
    }
    
    /**
    Tap handler on metric tab to push a ProgressViewController with the appropriate data
    
    - parameter recognizer: tap gesture calling this method
    */
    func openProgressView(recognizer: UITapGestureRecognizer) {
        let main = UIStoryboard.progressViewController()
        for index in 0...2 {
            if recognizer.view == self.availableTabs[index] {
                main?.viewType = self.routeExtension[index]
                break
            }
        }
        if let del = centerViewDelegate {
            // disable menu when pushing viewControllers
            del.togglePanGesture?(false)
            
            self.navigationController?.pushViewController(main!, animated: true)
        }
    }
    
    // MARK: MILWebViewDelegate Method
    
    /**
    Method called when a native action should be taken from a webview interaction
    
    - parameter pathComponents: components that help route to the appropriate action
    */
    func nativeViewHasChanged(pathComponents: Array<String>) {
        // Tapping UIWebView button removes web view in iOS 9
        if pathComponents.last == "vid_library" {
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
            // Load exercise data from server before navigating to VideoPlayerViewController
            var routineID : [String] = DataManager.dataManager.currentPatient.routineId
            let exerciseDataManager = ExerciseDataManager.exerciseDataManager
            exerciseDataManager.getExercisesForRoutine(routineID[0], callback: exerciseDataGathered)
        }
    }
    
    /**
    Callback method that gets called when data is returned from the server
    
    - parameter result: the result stating if the database call was successful
    */
    func exerciseDataGathered(result: ExerciseResultType) {
        SVProgressHUD.dismiss()
        if result == ExerciseResultType.Success {
            if let exercises = ExerciseDataManager.exerciseDataManager.exercises {
                if let first = exercises.first {
                    
                    let videoViewController = UIStoryboard.videoPlayerViewController()
                    videoViewController?.exerciseName = first.exerciseDescription == nil ? "" : first.exerciseDescription
                    videoViewController?.videoStats = (first.minutes.integerValue, first.repetitions.integerValue, first.sets.integerValue)
                    videoViewController?.tools = first.tools == nil ? "" : first.tools
                    videoViewController?.currentExercise = 1
                    videoViewController?.totalExercises = exercises.count
                    videoViewController?.currentVideoID = first.videoURL == nil ? "" : first.videoURL
                    self.navigationController?.pushViewController(videoViewController!, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Connection Error", comment: "n/a"), message: NSLocalizedString("Could not retrieve data from the server, try again later.", comment: ""), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            // ensure route is correct so get started button will work every time
            let reload = Utils.prepareCodeInjectionString("switchRoute('/WebView/dashboard', false)")
            self.webView.stringByEvaluatingJavaScriptFromString(reload)
        }
    }
    
    // MARK: Autolayout constraints
    
    /**
    Method lays out positioning of side tabs on the right
    */
    func setupAutoLayoutConstraints() {
        self.view.removeConstraints(self.view.constraints)
        
        // Tab size won't change so we may be able to remove constraints for tabs and just use storyboard placement
        self.heartTab.removeConstraints(self.heartTab.constraints)
        self.weightTab.removeConstraints(self.weightTab.constraints)
        self.stepsTab.removeConstraints(self.stepsTab.constraints)
        
        // Declare visualConstarint variables
        viewsDictionary["heartTab"] = self.heartTab
        viewsDictionary["weightTab"] = self.weightTab
        viewsDictionary["stepsTab"] = self.stepsTab
        viewsDictionary["caloriesTab"] = self.caloriesTab
        
        viewsDictionary["heartImageView"] = self.heartImageView
        viewsDictionary["heartRateTitle"] = self.heartRateTitle
        viewsDictionary["heartLabel"] = self.heartLabel
        viewsDictionary["bpmLabel"] = self.bpmLabel
        viewsDictionary["minHeartLabel"] = self.minHeartLabel
        viewsDictionary["minLabel"] = self.minLabel
        viewsDictionary["maxHeartLabel"] = self.maxHeartLabel
        viewsDictionary["maxLabel"] = self.maxLabel
        
        viewsDictionary["weightImageView"] = self.weightImageView
        viewsDictionary["weightTitle"] = self.weightTitle
        viewsDictionary["weightLabel"] = self.weightLabel
        viewsDictionary["poundsLabel"] = self.poundsLabel
        viewsDictionary["poundsLostLabel"] = self.poundsLostLabel
        viewsDictionary["thisWeekLabel"] = self.thisWeekLabel
        
        viewsDictionary["stepsImageView"] = self.stepsImageView
        viewsDictionary["stepTitle"] = self.stepTitle
        viewsDictionary["stepCountLabel"] = self.stepCountLabel
        viewsDictionary["firstGoalLabel"] = self.firstGoalLabel
        viewsDictionary["goalNumberLabel"] = self.goalNumberLabel
        viewsDictionary["secondGoalLabel"] = self.secondGoalLabel
        
        self.heartLabel.adjustsFontSizeToFitWidth = true
        self.stepCountLabel.adjustsFontSizeToFitWidth = true
        self.caloriesLabel.adjustsFontSizeToFitWidth = true
        self.weightLabel.adjustsFontSizeToFitWidth = true
        self.thisWeekLabel.adjustsFontSizeToFitWidth = true
        
        // declare helper constraint methods
        func fillViewWithImage(view: UIView, item: String) {
            view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[\(item)]|", options: [], metrics: nil, views: viewsDictionary))
            view.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|[\(item)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        routeExtension = ["metrics_hr_week", "metrics_weight_week", "metrics_steps_week"]
        
        // insert available tabs in array
        availableTabs.append(self.heartTab)
        availableTabs.append(self.weightTab)
        availableTabs.append(self.stepsTab)
        //availableTabs.append(self.caloriesTab)
        
        availableTabStrings.append("heartTab")
        availableTabStrings.append("weightTab")
        availableTabStrings.append("stepsTab")
        //availableTabStrings.append("caloriesTab")
        
        self.heartTab.hidden = false
        self.weightTab.hidden = false
        self.stepsTab.hidden = false
        self.caloriesTab.hidden = true
        
        let leftTabConstraintConstant = self.view.frame.size.width - initialTabWidth
        
        // firstTab constraints which can change based on availableTabs
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-80-[\(availableTabStrings[0])(90)]", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[\(availableTabStrings[0])(108)]", options: [], metrics: nil, views: viewsDictionary))
        
        // assign to a variable so we can animate later
        firstTabConstraint = NSLayoutConstraint(item: availableTabs[0], attribute: .Leading, relatedBy: .Equal,
            toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: leftTabConstraintConstant)
        self.view.addConstraint(firstTabConstraint)
        
        
        // secondTab constraints
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[\(availableTabStrings[0])]-10-[\(availableTabStrings[1])(90)]", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[\(availableTabStrings[1])(108)]", options: [], metrics: nil, views: viewsDictionary))
        secondTabConstraint = NSLayoutConstraint(item: availableTabs[1], attribute: .Leading, relatedBy: .Equal,
            toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: leftTabConstraintConstant)
        self.view.addConstraint(secondTabConstraint)
        
        // thirdTab constraints
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[\(availableTabStrings[1])]-10-[\(availableTabStrings[2])(90)]", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[\(availableTabStrings[2])(108)]", options: [], metrics: nil, views: viewsDictionary))
        thirdTabConstraint = NSLayoutConstraint(item: availableTabs[2], attribute: .Leading, relatedBy: .Equal,
            toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: leftTabConstraintConstant)
        self.view.addConstraint(thirdTabConstraint)
        
        
        // internal heartTab constraints
        fillViewWithImage(self.heartTab, item: "heartImageView")
        
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-7-[heartRateTitle(14)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-25-[heartRateTitle(60)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-35-[heartLabel(33)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[heartLabel(58)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-50-[bpmLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[heartLabel][bpmLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[heartLabel][minHeartLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[minHeartLabel(13)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[heartLabel][minLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[minHeartLabel]-2-[minLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[heartLabel][maxHeartLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[minLabel][maxHeartLabel(16)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[heartLabel][maxLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.heartTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[maxHeartLabel]-2-[maxLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        // internal weightTab constraints
        fillViewWithImage(self.weightTab, item: "weightImageView")
        
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-7-[weightTitle(14)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-25-[weightTitle(42)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-35-[weightLabel(33)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[weightLabel(58)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-50-[poundsLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[weightLabel][poundsLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[weightLabel][poundsLostLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[poundsLostLabel(14)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[weightLabel][thisWeekLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.weightTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[poundsLostLabel]-2-[thisWeekLabel(80)]", options: [], metrics: nil, views: viewsDictionary))
        
        // internal stepsTab constraints
        fillViewWithImage(self.stepsTab, item: "stepsImageView")
        
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-7-[stepTitle(14)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-25-[stepTitle(30)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-35-[stepCountLabel(33)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[stepCountLabel(95)]", options: [], metrics: nil, views: viewsDictionary))
        
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[stepCountLabel][firstGoalLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-10-[firstGoalLabel(28)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[stepCountLabel][goalNumberLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[firstGoalLabel][goalNumberLabel(24)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[stepCountLabel][secondGoalLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        self.stepsTab.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[goalNumberLabel]-2-[secondGoalLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        self.setupWebViewConstraints()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let del = centerViewDelegate {
            // disable menu when pushing viewControllers
            del.togglePanGesture?(false)
        }
    }
    
}
