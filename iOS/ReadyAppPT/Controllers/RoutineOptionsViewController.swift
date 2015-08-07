/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
View controller to show all the individual exercises.
*/
class RoutineOptionsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var videoRoutineTableView: UITableView!
    @IBOutlet weak var routineLabel: UILabel!
    var routineTitle = ""

    var currentExercises = ExerciseDataManager.exerciseDataManager.exercises
    var selectedCell: VideoTableViewCell?
    var selectedIndex: Int = 0
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        routineLabel.text = routineTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func popRoutineOptionsViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITableView delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentExercises.count
    }
    
    /**
    This table view sets all the info on each videoTableViewCell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell") as! VideoTableViewCell
        
        if var exercises = self.currentExercises {
            let exercise = exercises[indexPath.row]
            
            // Configure cell with video information
            // All data pulled from server except images, which are local
            let imageFile = "exercise_thumb\(indexPath.row + 1)"
            cell.thumbNail.image = UIImage(named: imageFile)
            cell.exerciseTitle.text = exercise.exerciseTitle == nil ? "" : exercise.exerciseTitle
            cell.exerciseDescription.text = exercise.exerciseDescription == nil ? "" : exercise.exerciseDescription
            cell.videoID = exercise.videoURL == nil ? "" : exercise.videoURL
            cell.tools = exercise.tools
            
            cell.setExerciseStats(exercise.minutes.integerValue, rep: exercise.repetitions.integerValue, sets: exercise.sets.integerValue)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? VideoTableViewCell
        selectedIndex = indexPath.row
        self.performSegueWithIdentifier("videoSegue", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "videoSegue" {
            let videoVC = segue.destinationViewController as! VideoPlayerViewController
            if let cell = selectedCell {
                videoVC.exerciseName = cell.exerciseDescription.text!
                videoVC.videoStats = cell.videoStats
                videoVC.tools = cell.tools
                videoVC.currentExercise = selectedIndex + 1
                videoVC.totalExercises = self.currentExercises.count
                videoVC.currentVideoID = cell.videoID
            }
            
        }
        
    }

}
