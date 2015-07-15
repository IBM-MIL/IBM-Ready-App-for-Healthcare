/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
*  Routine is a model of data representing the Routine assigned to a patient. This is an extension of IBMDataObject
*/
class Routine: NSObject {
    
    var id : String!
    var routineTitle : String!
    var exercises : [String]!
    
    override init() {
        
    }
    
    init(id : String, routineTitle : String, exercises: [String]) {
        super.init()
        self.id = id
        self.routineTitle = routineTitle
        self.exercises =  exercises
    }
}
