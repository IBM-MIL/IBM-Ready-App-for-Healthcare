/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Enum to report the state of the login attempt.
*/
enum LogInResultType {
    case Success
    case FailWrongUserID
    case FailWrongPassword
}

/**
Data Manager is a wrapper to the database connection
*/
class DataManager: NSObject, WLDataDelegate {
    private(set) var currentPatient : Patient!
    private(set) var routines : Routine!
    private(set) var exercises : Exercise!
    typealias LogInCallback = (LogInResultType)->Void
    var userId : String!
    
    var logInCallback: LogInCallback!
    //Class variable that will return a singleton when requested
    class var dataManager : DataManager{
        
        struct Singleton {
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    
    
    /**
    Method called by to sign in a user
    
    - parameter userID: string value passed from another class
    - parameter password: string value passed from another class
    - parameter callback: function from the class that called this function. Is executed with a enum as a parameter
    
    */
    func signIn(userID: String!, password: String!, callback: (LogInResultType)->()) {
        // Override point for customization after application launch.
        logInCallback = callback
        
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getUserObject"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [userID]
        self.userId = userID
        caller.invokeWithResponse(self, params: params)
    }
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    - parameter response: Response from WorkLight
    */
    func onSuccess(response: WLResponse!) {
        let responseJson = response.getResponseJson() as NSDictionary
        currentPatient = Patient(worklightResponseJson: responseJson)
        //routines = Routine(worklightResponseJson: responseJson)
        //exercises = Exercise(worklightResponseJson: responseJson)
        logInCallback(LogInResultType.Success)
    }
    
    /**
    Delgate method for WorkLight. Called when connection or return is unsuccessful
    
    - parameter response: Response from WorkLight
    */
    func onFailure(response: WLFailResponse!) {
        print(response.responseText)
        logInCallback(LogInResultType.FailWrongPassword)
    }
    
    /**
    Delgate method for WorkLight. Task to do before executing a call.
    */
    func onPreExecute() {
        
    }
    
    /**
    Delgate method for WorkLight. Task to do after executing a call.
    */
    func onPostExecute() {
        
    }
    
    /*
    Method called to get routines
    
    :param: userId
    
    */
    func getRoutines(userID: String!) {
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getRoutines"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [userID]
        caller.invokeWithResponse(self, params: params)
    }
    /*
    Method called to get routines
    
    :param: userId
    :param: routineTitle
    
    */
    func getRoutinesForPatient(routineId: String!) {
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getRoutinesForPatient"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [routineId]
        caller.invokeWithResponse(self, params: params)
    }
}