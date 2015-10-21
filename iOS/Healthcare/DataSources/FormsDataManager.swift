/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Enum to report the state of the forms data retrival
*/
enum FormsResultType {
    case Success
    case Failure
}

/**
Data Manager is a wrapper to the database connection
*/
class FormsDataManager: NSObject, WLDataDelegate {
    private(set) var forms : [Forms]!
    typealias FormsCallback = (FormsResultType)->Void
    
    var formsCallBack: FormsCallback!
    
    //Class variable that will return a singleton when requested
    class var formsDataManager : FormsDataManager{
        
        struct Singleton {
            static let instance = FormsDataManager()
        }
        return Singleton.instance
    }
    
    /**
    Delgate method for WorkLight. Called when connection and return is successful
    
    - parameter response: Response from WorkLight
    */
    func onSuccess(response: WLResponse!) {
        let responseJson = response.getResponseJson() as NSDictionary
        print("---formsDataManager onSuccess")
        print(response.responseText)
        // on success, call utils method to format data
        forms = Utils.getQuestionnaireForUser(responseJson)
        formsCallBack(FormsResultType.Success)
    }
    
    /**
    Delgate method for WorkLight. Called when connection or return is unsuccessful
    
    - parameter response: Response from WorkLight
    */
    func onFailure(response: WLFailResponse!) {
        print("---formsDataManager onFailure")
        print(response.responseText)
        formsCallBack(FormsResultType.Failure)
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
    
    - parameter username: the username to get questions for
    - parameter callback:  callback for when we have a result
    */
    func getQuestionnaireForUser(username: String!, callback: (FormsResultType)->()) {
        formsCallBack = callback
        
        let adapterName : String = "HealthcareAdapter"
        let procedureName : String = "getQuestionnaireForUser"
        let caller = WLProcedureCaller(adapterName : adapterName, procedureName: procedureName, dataDelegate: self)
        let params : [String] = [username]
        caller.invokeWithResponse(self, params: params)

    }
    
}