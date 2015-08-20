/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
*  Exercise is a model of data representing the current exercise the patient is performing. This is an extension of IBMDataObject
*/
class Exercise: NSObject {
    
    var id : String!
    var exerciseTitle : String!
    var exerciseDescription : String!
    var minutes : NSNumber!
    var repetitions : NSNumber!
    var sets : NSNumber!
    var image : String!
    var videoURL : String!
    var tools: String!
    var exerciseDictionary : NSDictionary!
    
    override init() {
        
    }
    
    init(id : String, exerciseTitle : String, description : String, minutes: NSNumber, repetitions: NSNumber, sets: NSNumber, image : String, videoURL : String, tools: String) {
        super.init()
        self.id = id
        self.exerciseTitle = exerciseTitle
        self.minutes = minutes
        self.repetitions = repetitions
        self.sets = sets
        self.image = image
        self.videoURL = videoURL
        self.tools = tools
    }
    
    
    init(worklightResponseJson: NSDictionary) {
        super.init()
        
//        self.id = jsonResult["_id"] as String
//        self.exerciseTitle = jsonResult["exerciseTitle"] as String
//        self.minutes = jsonResult["minutes"] as NSNumber
//        self.repetitions = jsonResult["repetitions"] as NSNumber
//        self.sets = jsonResult["sets"] as NSNumber
//        self.image = jsonResult["image"] as String!
//        self.videoURL = jsonResult["videoURL"] as String!
        
    }
    
    
}
