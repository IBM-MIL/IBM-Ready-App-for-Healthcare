/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

protocol CustomAlertViewDelegate {
    func handleAlertTap()
}

/**
Custom alert view that is highly stylelized to match the look and feel of the app.  This alert view simply displays a text label
and a small UI Image. The CustomAlertViewDelegate is used to pass control of taps to the encompassing view controller and is
intended to be used to hide the alert view.
*/
class CustomAlertView: UIView {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    
    var delegate: CustomAlertViewDelegate?
    
    /**
    The function used to initialize the CustomAlertView.
    
    - parameter text:      The text that will be displayed in the alert view. This will be limited to 2 lines.
    - parameter imageName: The name of the image to be displayed. This will be shown in a small 25x25 box.
    
    - returns: Returns the instance of the CustomAlertView
    */
    class func initWithText(text: String, imageName: String) -> CustomAlertView {
        let view = UINib(nibName: "CustomAlertView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CustomAlertView
        view.alertLabel.text = text
        view.imgView.image = UIImage(named: imageName)
        return view
    }
    
    /**
    Gesture recognizer to detect a tap. Passes the control to the delegate to dismiss the alert view.
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.handleAlertTap()
    }
}
