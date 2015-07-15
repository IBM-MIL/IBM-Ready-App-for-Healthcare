/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import MediaPlayer

/**
View Controller to display video and infor about the selected exercise
*/
class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate, CustomAlertViewExerciseDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var videoToolBar: UIToolbar!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    var currentTimeButton: UIBarButtonItem!
    var totalTimeButton: UIBarButtonItem!
    var currentTimeLabel: UILabel!
    var totalTimeLabel: UILabel!
    @IBOutlet weak var progressBarButton: UIBarButtonItem!
    @IBOutlet weak var progressSlider: UISlider!
    var airplayButton: UIBarButtonItem!
    var fullScreenButton: UIBarButtonItem!
    var flexSpace: UIBarButtonItem!
    var fixedSpace: UIBarButtonItem!
    
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var routineProgress: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var toolsLabel: UILabel!
    var alertView: CustomAlertViewExercise!
    
    var playerVars = Dictionary <String, Int>()
    var videoPlaying = false
    var isFullScreen = false
    var currentVideoID = "kflsEWkB2Zk"
    var currentTime: Float = 0
    var firstTimerStart = false
    
    var exerciseList = ExerciseDataManager.exerciseDataManager.exercises
    var currentExercise = 1
    var totalExercises = 4
    var exerciseComplete = false
    var exerciseName = ""
    var videoStats = (0,0,0)
    var tools = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensures spacing looks nice on larger screens
        if UIScreen.mainScreen().bounds.height > 568 {
            titleConstraint.constant = 15
        }
        
        self.navigationController?.navigationBar.translucent = false
        // if coming from dashboard, disable side panel
        if var presenting = self.navigationController?.viewControllers.first as? DashboardViewController {
            if var del = presenting.centerViewDelegate {
                del.togglePanGesture?(false)
            }
        }
        
        self.createVideoToolbarItems()
        self.toggleVideoControls()
        
        // Set video data values from server
        self.exerciseTitle.text = exerciseName
        self.exerciseTitle.adjustsFontSizeToFitWidth = true
        self.minutesLabel.text = Utils.formatSingleDigits(videoStats.0)
        self.repetitionsLabel.text = Utils.formatSingleDigits(videoStats.1)
        self.setsLabel.text = Utils.formatSingleDigits(videoStats.2)
        self.toolsLabel.text = tools
        routineProgress.text = "\(currentExercise) of \(totalExercises)"
        
        // Setup the alert view that will be displayed when the user goes to the next exercise
        var alertText = NSLocalizedString("Exercise Completed!", comment: "")
        var buttonText = NSLocalizedString("Start Next Exercise!", comment: "")
        var showSublabel = true
        if (currentExercise == totalExercises) {
            alertText = NSLocalizedString("Today's Routine Completed!", comment: "")
            buttonText = NSLocalizedString("Done", comment: "")
            showSublabel = false
        }
        self.alertView = CustomAlertViewExercise.initWithText(alertText, showSublabel: showSublabel, buttonText: buttonText)
        self.alertView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alertView.delegate = self
        self.alertView.hidden = true
        self.view.addSubview(alertView)
        self.setupAlertViewConstraints()
        
        // video player settings
        playerVars = ["playsinline": 1, "autohide":1, "controls":0, "modestbranding":1, "rel":0]

        self.playerView.loadWithVideoId(currentVideoID, playerVars: playerVars)
        self.playerView.delegate = self
        self.playerView.webView.mediaPlaybackAllowsAirPlay = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fullScreenExited", name: "UIWindowDidBecomeHiddenNotification", object: nil)
    }
  
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.playerView.pauseVideo()
        self.playerView.webView.stopLoading()
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
    }
    
    @IBAction func popVideoViewController(sender: AnyObject) {
        self.playerView.pauseVideo()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Method to create all the elements for the video toolbar
    */
    func createVideoToolbarItems() {
        
        var grayColor = UIColor(red: 204.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playVideo")
        playButton.tintColor = grayColor
        pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseVideo")
        pauseButton.tintColor = grayColor
        
        fullScreenButton = UIBarButtonItem(image: UIImage(named: "fullscreen_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "fullScreenVideo")
        fullScreenButton.tintColor = grayColor
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpace.width = -8.0
        
        currentTimeLabel = UILabel(frame: CGRectMake(0,0,30,44))
        currentTimeLabel.text = "0:00"
        currentTimeLabel.font = UIFont(name: "RobotoSlab-Bold", size: 12)
        currentTimeLabel.textColor = grayColor
        currentTimeLabel.textAlignment = NSTextAlignment.Center
        currentTimeButton = UIBarButtonItem(customView: currentTimeLabel)
        
        totalTimeLabel = UILabel(frame: CGRectMake(0,0,30,44))
        totalTimeLabel.text = "-0:00"
        totalTimeLabel.font = UIFont(name: "RobotoSlab-Bold", size: 12)
        totalTimeLabel.textColor = grayColor
        totalTimeButton = UIBarButtonItem(customView: totalTimeLabel)
        
        // for manual airplay controls
        var mediaPlayer = MPVolumeView(frame: CGRectMake(0, 0, 40, 44))
        mediaPlayer.showsVolumeSlider = false
        mediaPlayer.tintColor = grayColor
        airplayButton = UIBarButtonItem(customView: mediaPlayer)
        
        progressSlider.frame = CGRectMake(0,0,self.view.frame.size.width/3, 30)
        progressSlider.addTarget(self, action: "scrubVideo", forControlEvents: UIControlEvents.TouchUpInside)
        var thumbImage = UIImage(named: "thumb_slider")
        progressSlider.setThumbImage(thumbImage, forState: UIControlState.Normal)
        
    }
    
    /**
    Method to swap out the pause and play button on the video control toolbar.
    */
    func toggleVideoControls() {
        if videoPlaying {
            videoToolBar.items = [fixedSpace, pauseButton, flexSpace, currentTimeButton, progressBarButton,totalTimeButton, airplayButton, fullScreenButton, fixedSpace]
            
        } else {
            videoToolBar.items = [fixedSpace, playButton, flexSpace, currentTimeButton, progressBarButton,totalTimeButton, airplayButton, fullScreenButton, fixedSpace]
        }
    }
    
    /**
    Function to pause current youtube video
    */
    func pauseVideo() {
        self.playerView.pauseVideo()
    }
    
    /**
    Function to play current youtube video
    */
    func playVideo() {
        self.playerView.playVideo()
    }
    
    /**
    Method that prepares video player for full screen viewing. 
    Works by turning off playsinline and reloading the video.
    */
    func fullScreenVideo() {
        isFullScreen = true
        playerVars = ["playsinline": 0, "autohide":1, "controls":0, "modestbranding":1, "rel":0]
        currentTime = self.playerView.currentTime()
        self.playerView.loadWithVideoId(self.currentVideoID, playerVars: playerVars)
    }
    
    /**
    Method that prepares video player for inline video playing when coming from full screen.
    Works by turning on playsinline and reloading the video.
    */
    func fullScreenExited() {
        isFullScreen = false
        playerVars = ["playsinline": 1, "autohide":1, "controls":0, "modestbranding":1, "rel":0]
        currentTime = self.playerView.currentTime()
        self.playerView.loadWithVideoId(self.currentVideoID, playerVars: playerVars)
        
    }
    
    /*
        Delegate method to detect a change in state of the video player.
    */
    func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        if state.value == kYTPlayerStatePlaying.value {
            videoPlaying = true
            if !isFullScreen {
                toggleVideoControls()
            }
            if currentTime != 0 {
                self.playerView.seekToSeconds(currentTime, allowSeekAhead: true)
                currentTime = 0
            }
            if !firstTimerStart {
                var initialTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "videoTimeInterval", userInfo: nil, repeats: true)
                firstTimerStart = true
            }
            
            
        } else if state.value == kYTPlayerStatePaused.value {
            videoPlaying = false
            if !isFullScreen {
                toggleVideoControls()
            }
            
        } else if state.value == kYTPlayerStateEnded.value {
            self.progressSlider.value = self.progressSlider.maximumValue
            videoPlaying = false
            exerciseComplete = true
        }
    }
    
    /*
        Delegate method that sets up progressSlider initially.
    */
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        NSNotificationCenter.defaultCenter().postNotificationName("Playback started", object: self)
        if !isFullScreen {
            self.progressSlider.minimumValue = 0
            self.progressSlider.maximumValue = Float(self.playerView.duration()) - 1 // -1 because video starts at 0
            videoTimeInterval()
        }
 
        playerView.playVideo()

    }
    
    /**
    Called every half second to update the slider and number labels on the video control toolbar.
    */
    func videoTimeInterval() {
        var seconds = self.playerView.currentTime()
        var currentTime = computeTime(seconds)
        self.currentTimeLabel.text = "\(Int(currentTime.min)):\(Utils.formatSingleDigits(Int(currentTime.sec)))"
        
        var total = self.playerView.duration()
        var totalTime = computeTime(Float(total))
        self.totalTimeLabel.text = "-\(Int(totalTime.min - currentTime.min)):\(Utils.formatSingleDigits(Int(totalTime.sec - currentTime.sec)))"
       
        self.progressSlider.value = seconds
    }
    
    /**
    Method to compute the minutes and time from just seconds.
    
    :param: seconds total number of seconds to sort out.
    
    :returns: a tuple of minutes and seconds to update labels with.
    */
    func computeTime(seconds: Float) -> (min: Float, sec: Float) {
        var currentMinutes = seconds / 60;
        var currentSeconds = seconds % 60;
        return (currentMinutes, currentSeconds)
    }
    
    /**
    Called when a user interacts with the thumb scrubber.
    */
    func scrubVideo() {
        self.playerView.seekToSeconds(self.progressSlider.value, allowSeekAhead: true)
    }
    
    /**
    Method called when user clicks next routine
    
    :param: sender sending object
    */
    @IBAction func nextRoutine(sender: AnyObject) {

        self.playerView.pauseVideo()
        if currentExercise == totalExercises {
            // This was the last exercise so show alert saying that the Routine is completed
            self.alertView.hideSublabel()
            self.alertView.labelMain.text = NSLocalizedString("Today's Routine Completed!", comment: "")
            self.alertView.nextButton.setTitle(NSLocalizedString("Done", comment: ""), forState: UIControlState.Normal)
        } else {
            // Go to next exercise
            if !exerciseComplete {
                // Checks to see if the video finished playing. You could add an event here if you would like. We just want to go to the next
                // exercise when the user clicks the Next Exercise button.
            }
            self.alertView.showSublabel()
            self.alertView.labelMain.text = NSLocalizedString("Exercise Completed!", comment: "")
            self.alertView.nextButton.setTitle(NSLocalizedString("Start Next Exercise!", comment: ""), forState: UIControlState.Normal)
            self.alertView.startTimer()
        }
        self.alertView.hidden = false
    }
    
    /**
    Called when the next button or done button is pressed on the alert view
    */
    func handleNextButtonPressed() {
        if currentExercise == totalExercises {
            Utils.returnToDashboard()
        } else {
            resetVideoData()
        }
    }
    
    /**
    Method to reset the view controller for a new video with new data.
    */
    func resetVideoData() {
        var nextExercise = self.exerciseList[self.currentExercise]
        
        // set video data from the server for the next video
        self.exerciseTitle.text = nextExercise.exerciseDescription
        self.minutesLabel.text = Utils.formatSingleDigits(nextExercise.minutes.integerValue)
        self.repetitionsLabel.text = Utils.formatSingleDigits(nextExercise.repetitions.integerValue)
        self.setsLabel.text = Utils.formatSingleDigits(nextExercise.sets.integerValue)
        
        self.currentExercise++
        self.routineProgress.text = "\(self.currentExercise) of \(self.totalExercises)"
        
        self.toolsLabel.text = nextExercise.tools
        self.exerciseComplete = false
        
        self.playerView.loadWithVideoId(nextExercise.videoURL, playerVars: self.playerVars)
        
        // dismiss dark overlay
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.alertView.alpha = 0
        }, completion: {(done: Bool) in
            self.alertView.hidden = true
            self.alertView.alpha = 1.0
        })
    }
}
