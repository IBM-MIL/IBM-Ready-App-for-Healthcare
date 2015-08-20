/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
View Controller displayed when user wants to end exercise routine.
*/
class EndRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomAlertViewButtonsDelegate {
    
    var endRoutineString = NSLocalizedString("Why did you end your routine?", comment: "n/a")
    var questions = [
        NSLocalizedString("I'm hurting.", comment: "n/a"),
        NSLocalizedString("I'm tired.", comment: "n/a"),
        NSLocalizedString("I don't have time right now.", comment: "n/a"),
    ]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endRoutineLabel: UILabel!
    var alertView: CustomAlertViewButtons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endRoutineLabel.text = endRoutineString
        
        self.tableView.estimatedRowHeight = 55.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)      //elimanates any empty cells at the bottom of the table view
        
        // Setup the alert view that will be displayed when the user ends the routine
        var alertText = NSLocalizedString("Are you sure you want to end your routine?", comment: "")
        var alertColor = UIColor.readyAppBlue()
        self.alertView = CustomAlertViewButtons.initWithButtonColor(alertColor, alertText: alertText)
        self.alertView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertView.delegate = self
        self.alertView.hidden = true
        self.view.addSubview(alertView)
        self.setupAlertViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func popEndViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Called when Yes button is pressed on the alert view. Saves data, shows a confirmation alert, then pops to the root controller.
    */
    func handleAlertYesTap() {
        Utils.returnToDashboard()
    }
    
    func navigateToRoot() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**
    Called when No button is pressed on the alert view and hides the alert
    */
    func handleAlertNoTap() {
        self.alertView.hidden = true
    }
    
    /**
    Handles taps when the alert view is being shown. Just hide the alert view.
    */
    func handleAlertTap() {
        self.alertView.hidden = true
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! FormQuestionTableViewCell
        
        cell.questionLabel.text = questions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! FormQuestionTableViewCell
        cell.selectedCell()
    }

    @IBAction func finishedPressed(sender: AnyObject) {
        self.alertView.hidden = false
    }
}
