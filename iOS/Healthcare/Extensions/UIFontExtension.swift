/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

extension UIFont {
    
    class func printAllFontNames(){
        for family in UIFont.familyNames(){
            print(family)
            for font in UIFont.fontNamesForFamilyName((family )){
                print("\t\(font)")
            }
        }
    }
    
    class func readyAppRobotoSlabRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Regular", size: size)!
    }
    
    class func readyAppRobotoSlabBold(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Bold", size: size)!
    }
    
    class func readyAppRobotoSlabLight(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Light", size: size)!
    }
    
    class func readyAppRobotoSlabThin(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Thin", size: size)!
    }

    class func readyAppRobotoItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Italic", size: size)!
    }
    
    class func readyAppRobotoBlackItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-BlackItalic", size: size)!
    }
    
    class func readyAppRobotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    class func readyAppRobotoBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-BoldItalic", size: size)!
    }
    
    class func readyAppRobotoLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-LightItalic", size: size)!
    }
    
    class func readyAppRobotoThinItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-ThinItalic", size: size)!
    }
    
    class func readyAppRobotoBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Black", size: size)!
    }
    
    class func readyAppRobotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
    
    class func readyAppRobotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func readyAppRobotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    class func readyAppRobotoMediumItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-MediumItalic", size: size)!
    }
}

