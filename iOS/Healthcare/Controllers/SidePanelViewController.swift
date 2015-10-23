/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

var menuLabels = [NSLocalizedString("Home", comment: "n/a"),NSLocalizedString("Progress", comment: "n/a"), NSLocalizedString("Pain Management", comment: "n/a"), NSLocalizedString("Exercise Library", comment: "n/a") ,NSLocalizedString("Forms", comment: "n/a"),NSLocalizedString("Log Out", comment: "n/a")]

/**
This viewController is the sidePanel menu that holds data for the user as well as navigation options.
Autolayout constraints are done programmaticly in this viewController.
*/
class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var topHalfView: UIView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userIDTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextVisitLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var recoveryLabel: UILabel!
    var appDelegate : AppDelegate!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayoutConstraints()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID")!
        
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "RobotoSlab-Regular", size: 18)
        cell.textLabel!.text = menuLabels[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // make cells evenly take up half the height of the screen
        return (self.view.frame.size.height/2)/6
    }
    
    // set up our custom highlighting of the cell
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.readyAppDarkBlue()
        cell?.backgroundColor = UIColor.readyAppDarkBlue()
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.readyAppBlue()
        cell?.backgroundColor = UIColor.readyAppBlue()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            let container = self.containerVC()
            container?.updateCenterViewController(container!.centerViewController)
        }
        else if indexPath.row == 1 {
            let progressVC = UIStoryboard.progressViewController()
            progressVC?.viewType = "metrics"
            self.containerVC()?.updateCenterViewController(progressVC!)
            
        } else if indexPath.row == 2 {
            let painVC = UIStoryboard.painLocationViewController()
            self.containerVC()?.updateCenterViewController(painVC!)
        } else if indexPath.row == 3 {
            let exerciseVC = UIStoryboard.exerciseListViewController()
            self.containerVC()?.updateCenterViewController(exerciseVC!)
        } else if indexPath.row == 4 {
            let formsVC = UIStoryboard.formsViewController()
            self.containerVC()?.updateCenterViewController(formsVC!)
        } else if indexPath.row == 5 {
            appDelegate.logout("SingleStepAuthRealm")
            SVProgressHUD.dismiss()
            if DataManager.dataManager.currentPatient.userID == "user2"{
                let alert = UIAlertController(title: NSLocalizedString("Delete HealthKit Data", comment: "n/a"), message: NSLocalizedString("You are about to delete all data created by this app. Data created from other sources will be unaffected.", comment: "n/a"), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "n/a"), style: .Default) { (action) in
                    
                    // If okay, show HUD again, get permissions (which will call the function to load the data)
                    SVProgressHUD.showWithStatus(NSLocalizedString("Deleting HealthKit data...", comment: "n/a"))
                    
                    HealthKitManager.healthKitManager.deleteHealthKitData({
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.dismiss()
                            self.performSegueWithIdentifier("backToLoginSegue", sender: self)
                        }
                    })
                    
                    // Mark that the healthkit data has been deleted.
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "healthkit_populated")
                }
                
                alert.addAction(OKAction)
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "n/a"), style: .Default) { (action) in
                    
                    
                }
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                self.performSegueWithIdentifier("backToLoginSegue", sender: self)
            }
        }
    }
    
    /**
    Method to get a reference of the ContainerViewController
    
    - returns: the ContainerViewController instance
    */
    func containerVC() -> ContainerViewController? {
        if let viewController = self.parentViewController {
            if viewController.isKindOfClass(ContainerViewController.self) {
                return viewController as? ContainerViewController
            }
        }
        return nil
    }
    
    // MARK: Autolayout constraints
    
    func setupAutoLayoutConstraints() {
        self.view.removeConstraints(self.view.constraints)
        self.menuTableView.removeConstraints(self.menuTableView.constraints)
        self.topHalfView.removeConstraints(self.topHalfView.constraints)
        
        var viewsDictionary = Dictionary <String, UIView>()
        viewsDictionary["menuTableView"] = self.menuTableView
        viewsDictionary["topHalfView"] = self.topHalfView
        viewsDictionary["userIDLabel"] = self.userIDLabel
        viewsDictionary["userIDTitle"] = self.userIDTitle
        viewsDictionary["dateLabel"] = self.dateLabel
        viewsDictionary["nextVisitLabel"] = self.nextVisitLabel
        viewsDictionary["weekLabel"] = self.weekLabel
        viewsDictionary["recoveryLabel"] = self.recoveryLabel
        
        self.userIDLabel.adjustsFontSizeToFitWidth = true
        self.userIDTitle.adjustsFontSizeToFitWidth = true
        self.dateLabel.adjustsFontSizeToFitWidth = true
        self.nextVisitLabel.adjustsFontSizeToFitWidth = true
        self.weekLabel.adjustsFontSizeToFitWidth = true
        self.recoveryLabel.adjustsFontSizeToFitWidth = true
        
        // menu tableview constraints
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[menuTableView(\(self.view.frame.size.height/2))]|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[menuTableView(\(self.view.frame.size.width - 100))]", options: [], metrics: nil, views: viewsDictionary))
        // topHalfView constraints
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[topHalfView(\(self.view.frame.size.height/2))]", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[topHalfView(\(self.view.frame.size.width - 100))]", options: [], metrics: nil, views: viewsDictionary))
        
        // Base constraints off centering middle element
        self.topHalfView.addConstraint(
            NSLayoutConstraint(item: self.dateLabel, attribute: .CenterY, relatedBy: .Equal,
                toItem: self.topHalfView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
        // Next visit constraints
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[dateLabel(96)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[nextVisitLabel(68)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[dateLabel][nextVisitLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
        
        // UserID constraints
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[userIDLabel(128)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[userIDLabel(40)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[userIDTitle(50)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[userIDLabel][userIDTitle(20)]->=20-[dateLabel]", options: [], metrics: nil, views: viewsDictionary))
        
        // progress constraints
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[weekLabel(173)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[nextVisitLabel]->=20-[weekLabel(40)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-20-[recoveryLabel(140)]", options: [], metrics: nil, views: viewsDictionary))
        self.topHalfView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[weekLabel][recoveryLabel(20)]", options: [], metrics: nil, views: viewsDictionary))
    }
}
