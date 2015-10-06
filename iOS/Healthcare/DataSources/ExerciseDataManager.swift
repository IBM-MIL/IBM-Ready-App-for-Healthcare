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
    
    :param: response Response from WorkLight
    */
    func onSuccess(response: WLResponse!) {
        let responseJson = response.getResponseJson() as NSDictionary
        println("---exerciseDataManager onSuccess")
        println(response.responseText)
        //on success call utils method to format data
        exercises = Utils.getExercisesforRoutine(responseJson)
        exerciseCallBack(ExerciseResultType.Success)
    }
    
    /**
    Delgate method for WorkLight. Called when 
    connection or return is unsuccessful
    
    :param: response Response from WorkLight
    */
    func onFailure(response: WLFailResponse!) {
        println("---exerciseDataManager onFailure")
        println(response.responseText)
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
    
    :param: routineId the routine ID for a routine
    :param: callback  callback for when we have a result
    */
    func getExercisesForRoutine(routineId: String!, callback: (ExerciseResultType)->()) {
        exerciseCallBack = callback
        
        //isFromDashboard = true
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getExercisesForRoutine"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [routineId]
        caller.invokeWithResponse(self, params: params)
        var userExists = false
    }
}