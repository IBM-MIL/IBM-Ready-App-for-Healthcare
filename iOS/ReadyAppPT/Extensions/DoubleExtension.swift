/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation

extension Double {
    
    /**
    Double extension method that Formats a Double to a string as a specified format
    
    :param: f Format of the string
    
    :returns: String representation of the Double
    */
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}