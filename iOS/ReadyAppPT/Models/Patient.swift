/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Patient is a model of data representing the current user of the app. This is an extension of IBMDataObject
*/
class Patient: NSObject {
   
     var userID : String!
     var password : String!
     var dateOfNextVisit : NSDate!
     var visitsUsed : NSNumber!
     var visitsTotal : NSNumber!
     var stepGoal : NSNumber!
     var calorieGoal : NSNumber!
     var routineId : [String]!
     var questionnaire : String!
   
    /**
    An alternative init method that allows for populating all the properties of the object
    
    :param: userID          The ID of the patient
    :param: password        The password for the patient
    :param: dateOfNextVisit NSDate object representing the date of the next visit to doctor
    :param: visitsUsed      The number of visits the patient has used on visit plan
    :param: visitsTotal     The number of visits the patient has planned with doctor in total
    :param: stepGoal     The step goal for the patient as a number
    :param: calorieGoal     The calorie goal for the patient as a number
    
    */
    init(userID : String, password : String, dateOfNextVisit: NSDate, visitsUsed: NSNumber, visitsTotal: NSNumber, stepGoal : NSNumber, calorieGoal : NSNumber, routineId : [String]!, questionnaire : String!) {
        super.init()
        self.userID = userID
        self.password = password
        self.dateOfNextVisit = dateOfNextVisit
        self.visitsUsed = visitsUsed
        self.visitsTotal = visitsTotal
        self.stepGoal = stepGoal
        self.calorieGoal = calorieGoal
        self.routineId = routineId
        self.questionnaire = questionnaire
    }
    
    
    init(worklightResponseJson: NSDictionary) {
        super.init()
        
        
        let jsonResult = worklightResponseJson["result"] as! NSDictionary
        /*
        let stringResult = worklightResponseJson["result"] as! String
        let data = stringResult.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves, error: nil) as! NSDictionary
        */
        
        self.userID = jsonResult["userID"] as! String
        self.visitsUsed = jsonResult["visitsUsed"] as! NSNumber
        self.visitsTotal = jsonResult["visitsTotal"] as! NSNumber
        self.stepGoal = jsonResult["stepGoal"] as! NSNumber
        self.calorieGoal = jsonResult["calorieGoal"] as! NSNumber
        
        let dateOfNextVisitString = jsonResult["dateOfNextVisit"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        self.dateOfNextVisit = formatter.dateFromString(dateOfNextVisitString)
        self.routineId = jsonResult["routines"] as! [String]
        self.questionnaire = jsonResult["questionnaire"] as! String
    }
    

}
