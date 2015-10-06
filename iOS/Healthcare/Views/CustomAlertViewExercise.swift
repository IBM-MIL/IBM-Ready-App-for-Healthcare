/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

protocol CustomAlertViewExerciseDelegate {
    func handleNextButtonPressed()
}

/**
Custom alert view that is highly stylelized to match the look and feel of the app.  This alert view displays a text label, and image view, and
two buttons. The CustomAlertViewExerciseDelegate is used to pass control of handling button presses to the owning view controller.
*/
class CustomAlertViewExercise: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var sublabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    var WITH_SUBLABEL_TOP_CONST: CGFloat = 8
    var WITHOUT_SUBLABEL_TOP_CONST: CGFloat = 16
    var TIMER_START = 10
    
    var timer: NSTimer?
    var delegate: CustomAlertViewExerciseDelegate?
    var timerValue: Int!
    
    /**
    Function to initialize the alert view.
    
    :param: alertText    The text that will be shown in the main label.
    :param: showSublabel Indicates whether or not to show the sublabel which contains the countdown timer to the next exercise.
    :param: buttonText   The text to be displayed in the button.
    
    :returns: An instance of the alert view.
    */
    class func initWithText(alertText: String, showSublabel: Bool, buttonText: String) -> CustomAlertViewExercise {
        var view = UINib(nibName: "CustomAlertViewExercise", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CustomAlertViewExercise
        view.labelMain.text = alertText
        view.nextButton.setTitle(buttonText, forState: UIControlState.Normal)
        
        if showSublabel {
            view.showSublabel()
        } else {
            view.hideSublabel()
        }
        view.timerValue = view.TIMER_START
        return view
    }

    /**
    When the next button is clicked, invalidate the timer if it exists and pass control to the delegate.
    */
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if timer != nil {
            timer?.invalidate()
        }
        self.delegate?.handleNextButtonPressed()
    }
    
    /**
    When called this starts a timer to decrement the text in the sublabel.
    */
    func startTimer() {
        var newText = NSLocalizedString("Your next exercise will start in 0:10", comment: "")
        self.sublabel.text = newText
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimerLabel:"), userInfo: nil, repeats: true)
        timerValue = TIMER_START
    }
    
    /**
    Updates the timer text in the sublabel.  When the timer reaches -1, the timer is stopped and triggers a 'Next' button press.
    */
    func updateTimerLabel(timer: NSTimer) {
        timerValue = timerValue - 1
        if timerValue == -1 {
            timer.invalidate()
            self.delegate?.handleNextButtonPressed()
        } else {
            var newText = NSLocalizedString("Your next exercise will start in 0:0", comment: "")
            self.sublabel.text = newText + "\(timerValue)"
        }
    }
    
    /**
    Hides the sublabel and shifts the image view and label down
    */
    func hideSublabel() {
        self.sublabel.hidden = true
        self.imageViewTopConstraint.constant = WITHOUT_SUBLABEL_TOP_CONST
        self.layoutIfNeeded()
    }
    
    /**
    Shows the sublabel and shifts the image view and label up
    */
    func showSublabel() {
        self.imageViewTopConstraint.constant = WITH_SUBLABEL_TOP_CONST
        self.layoutIfNeeded()
    }
}