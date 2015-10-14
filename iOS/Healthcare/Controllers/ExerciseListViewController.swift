/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
View controller to display a list of exercise categories.
*/
class ExerciseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomAlertViewDelegate {
    
    var areaTypes = [NSLocalizedString("Assigned", comment: "n/a"), NSLocalizedString("Neck", comment: "n/a"), NSLocalizedString("Back", comment: "n/a") , NSLocalizedString("Torso", comment: "n/a"), NSLocalizedString("Arm", comment: "n/a"), NSLocalizedString("Hand", comment: "n/a"), NSLocalizedString("Leg", comment: "n/a"), NSLocalizedString("Feet", comment: "n/a")]

    @IBOutlet weak var exerciseTableView: UITableView!
    var alertViewSimple: CustomAlertView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var dataReturned = (routine: RoutineResultType.Unknown, exercise: ExerciseResultType.Unknown)
    var alertText = NSLocalizedString("Assets not added yet.", comment: "")
    var noDataAlertText = NSLocalizedString("Could not retrieve data from the server, try again later.", comment: "")
    var appDelegate : AppDelegate!
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.rootViewMenu(self.parentViewController!, disablePanning: true)
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.enabled = false
        
        // Setup the alert view
        
        let alertImageName = "x_blue"
        alertViewSimple = CustomAlertView.initWithText(alertText, imageName: alertImageName)
        alertViewSimple.translatesAutoresizingMaskIntoConstraints = false
        alertViewSimple.delegate = self
        alertViewSimple.hidden = true
        self.view.addSubview(alertViewSimple)
        self.setupAlertViewConstraints()
        
        //send notification to challenge handler
        let userInfo:Dictionary<String,UIViewController!> = ["ExerciseListViewController" : self]
        NSNotificationCenter.defaultCenter().postNotificationName("viewController", object: nil, userInfo: userInfo)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataReturned = (RoutineResultType.Unknown, ExerciseResultType.Unknown)
        
    }
    
    /**
    Notifies the ReadyAppsChallengeHandler that another view controller has been placed on top of the exercise list view controller
    */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let userInfo:Dictionary<String,Bool!> = ["ExerciseListViewController" : false]
        NSNotificationCenter.defaultCenter().postNotificationName("disappear", object: nil, userInfo: userInfo)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Setups the the custom alert view to fill the entire view
    */
    func setupAlertViewConstraints() {
        var viewsDict = Dictionary<String, UIView>()
        
        viewsDict["alertView"] = self.alertViewSimple
        viewsDict["view"] = self.view
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
    }
    
    /**
    Custom alert view delegate method that is triggered when the alert view is tapped.
    */
    func handleAlertTap() {
        self.alertViewSimple.hidden = true
        self.alertViewSimple.alertLabel.text = alertText
    }
    
    /**
    Method to open the side panel
    */
    func openSideMenu() {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.exerciseTableView.userInteractionEnabled = false
        tapGestureRecognizer.enabled = true
    }
    
    /**
    Method to handle taps when the side menu is open
    
    - parameter recognizer: tap gesture used to call method
    */
    func handleTap(recognizer: UITapGestureRecognizer) {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        
        // check if expanded so tapgesture isn't enabled when it shouldn't be
        if container.currentState == SlideOutState.LeftExpanded {
            container.toggleLeftPanel()
            self.exerciseTableView.userInteractionEnabled = true
            tapGestureRecognizer.enabled = false
        } else {
            self.exerciseTableView.userInteractionEnabled = true
            tapGestureRecognizer.enabled = false
        }
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell") as! ListTableViewCell
        
        if indexPath.row == 0 {
            cell.primaryLabel.textColor = UIColor.readyAppBlue()
        }

        cell.primaryLabel.text = areaTypes[indexPath.row]
        return cell
    }

    /**
    Handles a selection of the table view. If "Assigned" is selected, segue to the next view controller. Otherwise show
    an alert notifying the user that those assets are not available.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
            
            let routineDataManager = RoutineDataManager.routineDataManager
            routineDataManager.getRoutines(DataManager.dataManager.currentPatient.userID, callback: routineDataGathered)
            
            //check if routines has been populated since they could be invoked when the user has timedout
            //if rountines is nil, make sure it has been populated before moving on
            
            var routineID : [String] = DataManager.dataManager.currentPatient.routineId
            let exerciseDataManager = ExerciseDataManager.exerciseDataManager
            exerciseDataManager.getExercisesForRoutine(routineID[0], callback: exerciseDataGathered)
            
            
        } else {
            self.alertViewSimple.hidden = false
        }
    }
    
    /**
    Callback method that gets called when data is returned from the server
    
    - parameter result: the result stating if the database call was successful
    */
    func routineDataGathered(result: RoutineResultType) {
        dataReturned.routine = result
        if result == RoutineResultType.Success {
            
            if dataReturned.routine == RoutineResultType.Success && dataReturned.exercise == ExerciseResultType.Success {
                SVProgressHUD.dismiss()
                self.performSegueWithIdentifier("routineSegue", sender: nil)
            }
        } else {
            if dataReturned.routine == RoutineResultType.Failure && dataReturned.exercise == ExerciseResultType.Failure {
                SVProgressHUD.dismiss()
                self.alertViewSimple.alertLabel.text = noDataAlertText
                self.alertViewSimple.hidden = false
            }
        }
    }
    
    /**
    Callback method that gets called when data is returned from the server (in the case that user is logged in and
    there was no timeout. In the case of a user timeout, the ReadyAppsChallengeHandler:customResponse is called.
    
    - parameter result: the result stating if the database call was successful
    */
    func exerciseDataGathered(result: ExerciseResultType) {
        dataReturned.exercise = result
        if result == ExerciseResultType.Success {
            
            if dataReturned.routine == RoutineResultType.Success && dataReturned.exercise == ExerciseResultType.Success {
                SVProgressHUD.dismiss()
                self.performSegueWithIdentifier("routineSegue", sender: nil)
            }
        } else {
            if dataReturned.routine == RoutineResultType.Failure && dataReturned.exercise == ExerciseResultType.Failure {
                SVProgressHUD.dismiss()
                self.alertViewSimple.alertLabel.text = noDataAlertText
                self.alertViewSimple.hidden = false
                
            }
        }
    }

}
