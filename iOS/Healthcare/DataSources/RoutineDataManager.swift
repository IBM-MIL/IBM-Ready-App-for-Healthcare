/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Enum to report the state of the login attempt.
*/
enum RoutineResultType {
    case Success
    case Failure
    case Unknown
}

/**
Data Manager is a wrapper to the database connection
*/
class RoutineDataManager: NSObject, WLDataDelegate {
    private(set) var routines : [Routine]!
    typealias RoutineCallback = (RoutineResultType)->Void
    
    var routineCallback: RoutineCallback!
    
    //Class variable that will return a singleton when requested
    class var routineDataManager : RoutineDataManager{
        
        struct Singleton {
            static let instance = RoutineDataManager()
        }
        return Singleton.instance
    }
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    - parameter response: Response from WorkLight
    */
    func onSuccess(response: WLResponse!) {
        let responseJson = response.getResponseJson() as NSDictionary
        print("---routinesDataManager onSuccess")
        print(response.responseText)
        // on success, call utils method to format data
        routines = Utils.getRoutines(responseJson)
        routineCallback(RoutineResultType.Success)
    }
    
    /**
    Delgate method for WorkLight. Called when connection or return is unsuccessful
    
    - parameter response: Response from WorkLight
    */
    func onFailure(response: WLFailResponse!) {
        print("---routinesDataManager onFailure")
        print(response.responseText)
        routineCallback(RoutineResultType.Failure)
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
    
    /**
    Method called to get routines from the server
    
    - parameter userID: the user ID to get routine data for
    - parameter callback:  callback for when we have a result
    */
    func getRoutines(userID: String!, callback: (RoutineResultType)->()) {
        routineCallback = callback
        
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getRoutines"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [userID]
        caller.invokeWithResponse(self, params: params)
    }
}