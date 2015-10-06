/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func readyAppRed() -> UIColor {
        return UIColor(red: 218.0/255.0, green: 87.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    
    class func readyAppBlack() -> UIColor {
        return UIColor(red: 56.0/255.0, green: 54.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
    
    class func readyAppBlue() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 178.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }
    
    class func readyAppDarkBlue() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 138.0/255.0, blue: 191.0/255.0, alpha: 1.0)
    }
}