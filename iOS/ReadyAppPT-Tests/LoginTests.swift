/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest

/**
*  Class to test login capabilities through the DataManager object - * not currently working *
*/
class LoginTests: XCTestCase {
    
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager.dataManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDataManager() {
//        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        appDelegate.submitAuthentication("user1", password: "password1")
//        dataManager.signIn("user1", password: "password1", callback: testLogin)
    }
    
    func testLogin(result: LogInResultType) {
        
        XCTAssertNotNil(result.hashValue, "Login result cannot be nil")
        if (result == LogInResultType.Success) {
            XCTAssertEqual(result, LogInResultType.Success, "Result is not success as expected")
        } else if(result == LogInResultType.FailWrongPassword){
            XCTAssertEqual(result, LogInResultType.FailWrongPassword, "Result is not wrong password as expected")
        } else if(result == LogInResultType.FailWrongPassword){
            XCTAssertEqual(result, LogInResultType.FailWrongPassword, "Result is not wrong user ID as expected")
        }
    }
    
    func testPerformanceExample() {
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
   
}
