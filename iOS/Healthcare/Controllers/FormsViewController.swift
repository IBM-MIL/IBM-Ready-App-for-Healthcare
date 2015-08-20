/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
This view controller presents a Questionnaire for the user to answer when they arrive at the Doctor's office.  These questions can 
be easily updated by changing the 'questions' variable.  The table view has been setup to automatically expand based on the size of the question
so if the question is very long it will all be displayed.
*/
class FormsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var formsDataManager = FormsDataManager.formsDataManager
    var thePatient =  DataManager.dataManager.currentPatient
    var currentForms: [Forms]!

    // local questions in case server retrieves no data
    var questions = [
        NSLocalizedString("Had tests for this condition", comment: "n/a"),
        NSLocalizedString("Had similar condition before", comment: "n/a"),
        NSLocalizedString("Symptoms have worsened", comment: "n/a"),
        NSLocalizedString("Pain at rest", comment: "n/a"),
        NSLocalizedString("Pain with activity", comment: "n/a"),
        NSLocalizedString("Pain wakes you up at night", comment: "n/a"),
        NSLocalizedString("Smoke tobacco", comment: "n/a"),
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        formsDataManager.getQuestionnaireForUser(thePatient.userID, callback: formsDataGathered)

        Utils.rootViewMenu(self.parentViewController!, disablePanning: true)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.enabled = false
        
        self.tableView.estimatedRowHeight = 55.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero) // eliminates any empty cells at the bottom of the table view
        
        //send notification to challenge handler
        let userInfo:Dictionary<String,UIViewController!> = ["FormsViewController" : self]
        NSNotificationCenter.defaultCenter().postNotificationName("viewController", object: nil, userInfo: userInfo)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    /**
    Notifies the ReadyAppsChallengeHandler that another view controller has been placed on top of the forms view controller
    */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let userInfo:Dictionary<String,Bool!> = ["FormsViewController" : false]
        NSNotificationCenter.defaultCenter().postNotificationName("disappear", object: nil, userInfo: userInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Callback method that gets called when data has been returned from server
    
    :param: result the result stating if the database call was successful
    */
    func formsDataGathered(result: FormsResultType) {
        SVProgressHUD.dismiss()
        if result == FormsResultType.Success {
            currentForms = FormsDataManager.formsDataManager.forms
            tableView.reloadData()
        }
    }
    
    /**
    Method to open the side panel
    */
    func openSideMenu() {
        var container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.tableView.userInteractionEnabled = false
        tapGestureRecognizer.enabled = true
    }
    
    /**
    Method to handle taps when the side menu is open
    
    :param: recognizer tap gesture used to call method
    */
    func handleTap(recognizer: UITapGestureRecognizer) {
        var container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.tableView.userInteractionEnabled = true
        tapGestureRecognizer.enabled = false
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! FormQuestionTableViewCell
        
        if var forms = self.currentForms {
            var form = forms[indexPath.row]
            cell.questionLabel.text = form.textDescription
        } else {
            cell.questionLabel.text = questions[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! FormQuestionTableViewCell
        cell.selectedCell()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToPainFromNext" {
            var vc: PainLocationViewController = segue.destinationViewController as! PainLocationViewController
            vc.useBlueColor = true
        }
    }

}
