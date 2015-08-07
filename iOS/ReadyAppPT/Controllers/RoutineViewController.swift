/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
View controller to display all the routines available under a certain category.
*/
class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var routineTableView: UITableView!
    var currentRoutines = RoutineDataManager.routineDataManager.routines
    var selectedTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("in routineViewController viewDidLoad()")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func popRoutineViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentRoutines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("routineCell") as! ListTableViewCell

        if var routines = self.currentRoutines {
            let routine = routines[indexPath.row]
            cell.primaryLabel.text = routine.routineTitle
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if var routines = self.currentRoutines {
            selectedTitle = routines[indexPath.row].routineTitle
        }
        self.performSegueWithIdentifier("routineDetailSegue", sender: nil)
    }
    
    // set up our custom highlighting of the cell
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListTableViewCell
        cell.contentView.backgroundColor = UIColor.readyAppDarkBlue()
        cell.backgroundColor = UIColor.readyAppDarkBlue()
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListTableViewCell
        cell.contentView.backgroundColor = UIColor.readyAppBlue()
        cell.backgroundColor = UIColor.readyAppBlue()
    }
    
    // MARK: - Navigation

    // Prepare storyboard view controller with necessary data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "routineDetailSegue" {
            let routineOptionsVC = segue.destinationViewController as! RoutineOptionsViewController
            routineOptionsVC.routineTitle = selectedTitle
        }
    }
    

}
