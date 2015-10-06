/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest

/**
*  Class to test all methods in the DoubleExtension class.
*/
class DoubleExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    Method that test doubles are formatted as desired through the extension.
    */
    func testDoubleFormat() {
        var firstDouble: Double = 3.1426
        var secondDouble: Double = 123.98
        var desiredFormat = ".0"
        
        var formattedOne = firstDouble.format(desiredFormat)
        XCTAssertEqual(formattedOne, "3", "format returned \(formattedOne) when it should have returned 3")
        
        formattedOne = secondDouble.format(desiredFormat)
        XCTAssertEqual(formattedOne, "124", "format returned \(formattedOne) when it should have returned 123")
        
        desiredFormat = ".2"
        
        formattedOne = firstDouble.format(desiredFormat)
        XCTAssertEqual(formattedOne, "3.14", "format returned \(formattedOne) when it should have returned 3.14")
        
        formattedOne = secondDouble.format(desiredFormat)
        XCTAssertEqual(formattedOne, "123.98", "format returned \(formattedOne) when it should have returned 123.98")
    }
    
    func testPerformanceExample() {
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
   
}
