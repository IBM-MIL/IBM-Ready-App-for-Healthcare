/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation


// Utility class that wraps the behavior for making a Worklight procedure call.
// An instance of this class should be created from the View Controller class
// that depends on the result on the procedure call.

protocol WLDataDelegate : WLDelegate {
    func onSuccess(response : WLResponse!)
    func onFailure(response : WLFailResponse!)
    func onPreExecute()
    func onPostExecute()
    
}

class WLProcedureCaller {
   
    var dataDelegate:WLDataDelegate!
    var adapterName : String!
    var procedureName : String!
    var response : WLDelegate!
    var logWLStartTime : NSDate!
    let TIMEOUT_MILLIS : Int = 3000
    
    init(adapterName : String, procedureName: String, dataDelegate: WLDataDelegate){
        self.adapterName = adapterName
        self.procedureName = procedureName
        self.dataDelegate = dataDelegate        
    }
    
    func invokeWithResponse(response: WLDelegate, params: Array<String>){
        self.response = response
        self.dataDelegate.onPreExecute()
        
        let invocationData = WLProcedureInvocationData(adapterName: adapterName, procedureName: procedureName)
        invocationData.parameters = params
        
        //Timeout value in milliseconds
        let options = NSDictionary(object:TIMEOUT_MILLIS, forKey: "timeout")
        
        logWLStartTime = NSDate()
        
        WLClient.sharedInstance().invokeProcedure(invocationData, withDelegate: self.dataDelegate, options:options as [NSObject : AnyObject])
    }
    
    func onSuccess(response: WLResponse){
        // let elapsedTime = NSDate().timeIntervalSinceDate(logWLStartTime)
        self.dataDelegate.onPostExecute()
        self.response.onSuccess(response)
    }
    
    func onFailure(response: WLFailResponse){
        var resultText : String = "Invocation Failure"
        if(response.responseText != nil){
           //append to response text
            resultText = resultText + response.responseText
            print(resultText)
        }
        self.dataDelegate.onPostExecute()
        self.response.onFailure(response)
        
    }
    
}
