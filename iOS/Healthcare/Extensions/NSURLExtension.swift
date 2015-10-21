/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation

/**
*  NSURL extension to parse URLs for internal navigation.
*/
extension NSURL {
    
    /**
    NSURL extension method to parse a URL, gathering the last components to perform the appropriate action on the return value
    
    - returns: (object, action) a tuple with the object to make and the action to perform
    */
    func urlParser() -> (object: String, action: String) {
        let absString = self.absoluteString
        
        // get everything after .html and parse components
        let relevantPath = absString.componentsSeparatedByString(self.lastPathComponent!).last
        var params = relevantPath!.componentsSeparatedByString("/") as Array<String>
        
        // return a tuple of important data
        if params.count == 3 {
            let one = params[1] as String
            let two = params[2] as String
            return (one, two)
        } else if params.count == 2 {
            let one = params[1] as String // on main page
            return (one, "")
        }
        return ("", "")
    }
}
