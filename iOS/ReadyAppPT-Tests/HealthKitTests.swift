/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest

/**
*  Test class to verify healthkit data is working properly
*/
class HealthKitTests: XCTestCase {
    
    var hkManager: HealthKitManager!
    var comps = NSDateComponents()
    var startDate: NSDate!
    
    override func setUp() {
        super.setUp()
        
        hkManager = HealthKitManager.healthKitManager
        
        comps.day = 01
        comps.month = 11
        comps.year = 2014
        startDate = NSCalendar.currentCalendar().dateFromComponents(comps)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    This test verifies the singleton is working properly
    */
    func testIsSingleton() {
        let newManager = HealthKitManager.healthKitManager
        XCTAssertEqual(hkManager, newManager, "Managers are not the same instance")
    }
    
    // MARK: test healthkit metrics
    
    // TODO: need to populate data first and then verify in the following methods.
    func testHeartRate() {
        HealthKitManager.healthKitManager.getHeartRateData(startDate!, callback: { (data, err) in
            if err == nil {
                //XCTAssertTrue(data != nil, "Heart Rate data should not be nil")
            }
        })
    }
    
    func testStepsData() {
        HealthKitManager.healthKitManager.getSteps(startDate!, callback: { (steps, error) in
            if error == nil{
                XCTAssertTrue(steps >= 0, "steps is not greater than or equal to zero")
            }
        })
    }
    
    func testWeightInPoundsData() {
        HealthKitManager.healthKitManager.getWeightInPoundsData(startDate!, callback: { (data, err) in
            if err == nil {
                //XCTAssertTrue(data != nil, "Weight data should not be nil")
                // example:
                //XCTAssertTrue(data[HeartRateData.Average.toRaw()] == 79, "\(data[HeartRateData.Average.toRaw()]) is not the expected heart rate average of 79")
            }
        })
    }
    
    func testCaloriesBurnt() {
        HealthKitManager.healthKitManager.getCaloriesBurned(startDate!, callback: { (calories, error) in
            if error == nil{
                XCTAssertTrue(calories >= 0, "Calories data should not be nil")
            }
        })
    }
   
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}
