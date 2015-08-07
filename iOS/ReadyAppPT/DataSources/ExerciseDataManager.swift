/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Enum to report the state of the exercise data retrival
*/
enum ExerciseResultType {
    case Success
    case Failure
    case Unknown
}

/**
Data Manager is a wrapper to the database connection
*/
class ExerciseDataManager: NSObject, WLDataDelegate {
    private(set) var exercises : [Exercise]!
    typealias ExerciseCallback = (ExerciseResultType)->Void
    
    var exerciseCallBack: ExerciseCallback!
    var isFromDashboard : Bool = false
    
    //Class variable that will return a singleton when requested
    class var exerciseDataManager : ExerciseDataManager{
        
        struct Singleton {
            static let instance = ExerciseDataManager()
        }
        return Singleton.instance
    }
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    - parameter response: Response from WorkLight
    */
    func onSuccess(response: WLResponse!) {
        let responseJson = response.getResponseJson() as NSDictionary
        print("---exerciseDataManager onSuccess")
        print(response.responseText)
        //on success call utils method to format data
        exercises = Utils.getExercisesforRoutine(responseJson)
        exerciseCallBack(ExerciseResultType.Success)
    }
    
    /**
    Delgate method for WorkLight. Called when 
    connection or return is unsuccessful
    
    - parameter response: Response from WorkLight
    */
    func onFailure(response: WLFailResponse!) {
        print("---exerciseDataManager onFailure")
        print(response.responseText)
        exerciseCallBack(ExerciseResultType.Failure)
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
    Method called to get exercises from the server
    
    - parameter routineId: the routine ID for a routine
    - parameter callback:  callback for when we have a result
    */
    func getExercisesForRoutine(routineId: String!, callback: (ExerciseResultType)->()) {
        exerciseCallBack = callback
        
        //isFromDashboard = true
        let adapterName : String = "ReadyAppsAdapter"
        let procedureName : String = "getExercisesForRoutine"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [routineId]
        caller.invokeWithResponse(self, params: params)
        var userExists = false
    }
}