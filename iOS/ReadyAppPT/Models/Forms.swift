/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
*  Exercise is a model of data representing the current exercise the patient is performing. This is an extension of IBMDataObject
*/
class Forms: NSObject {
    
    var id : String!
    var textDescription : String!
    var type : String!
    
    override init() {
        
    }
    
    init(id : String, textDescription : String, type: String) {
        super.init()
        self.id = id
        self.textDescription = textDescription
        self.type = type
    }
    
    init(worklightResponseJson: NSDictionary) {
        super.init()
        
        let stringResult = worklightResponseJson["result"] as! String
        let data = stringResult.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
        
        self.id = jsonResult["_id"] as! String
        self.textDescription = jsonResult["textDescription"] as! String
        self.type = jsonResult["type"] as! String
    }
    
    
}
