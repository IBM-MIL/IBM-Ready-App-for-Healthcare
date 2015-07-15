/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

protocol CustomAlertViewButtonsDelegate {
    func handleAlertTap()
    func handleAlertYesTap()
    func handleAlertNoTap()
}

/**
Custom alert view that is highly stylelized to match the look and feel of the app.  This alert view displays a text label and
two buttons. The CustomAlertViewButtonsDelegate is used to pass control of taps and button presses to the encompassing view controller.
*/
class CustomAlertViewButtons: UIView {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var delegate: CustomAlertViewButtonsDelegate?
    
    /**
    The function used to initialize the alert view.
    
    :param: buttonColor Sets the background color of the two buttons.
    :param: alertText   Changes the text of the label
    
    :returns: Returns an instance of the CustomAlertViewButtons
    */
    class func initWithButtonColor(buttonColor: UIColor, alertText: String) -> CustomAlertViewButtons {
        var view = UINib(nibName: "CustomAlertViewButtons", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CustomAlertViewButtons
        view.alertLabel.text = alertText
        view.yesButton.backgroundColor = buttonColor
        view.yesButton.setTitle(NSLocalizedString("Yes", comment:""), forState: UIControlState.Normal)
        view.noButton.backgroundColor = buttonColor
        view.noButton.setTitle(NSLocalizedString("No", comment:""), forState: UIControlState.Normal)
        return view
    }
    
    /**
    Gesture tap recognizer. Passes control to the delegate
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.delegate?.handleAlertTap()
    }
    
    /**
    Action called when the Yes button is pressed. Passes control to the delegate.
    */
    @IBAction func yesButtonClicked(sender: AnyObject) {
        self.delegate?.handleAlertYesTap()
    }
    
    /**
    Action called when the No button is pressed. Passes control to the delegate.
    */
    @IBAction func noButtonPressed(sender: AnyObject) {
        self.delegate?.handleAlertNoTap()
    }
}