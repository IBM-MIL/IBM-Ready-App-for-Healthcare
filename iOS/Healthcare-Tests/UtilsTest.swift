/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest
@testable import Healthcare

/**
*  Unit tests for various methods in the Utils class.
*/
class UtilsTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    Method to test every single digit number gets a 0 prefix on it.
    */
    func testSingleDigitFormat() {
        let noPrefix = Utils.formatSingleDigits(5)
        XCTAssertEqual(noPrefix, "05", "zero was not added in front of the digit")
        
        let withPrefix = Utils.formatSingleDigits(05)
        XCTAssertEqual(withPrefix, "05", "\(withPrefix) does not match 05")
    }
    
    /**
    Method to test we can extract the correct data from an NSDate.
    */
    func testDateExtraction() {
        let myDate = "Mon, 06 Sep 2009 16:45:00 -0900"
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let sepDate = dateFormatter.dateFromString(myDate)
        
        let month = Utils.extractMonthNameFromDate(sepDate!)
        XCTAssertEqual(month, "September", "Month returned is not September")
        
        let day = Utils.extractDayFromDate(sepDate!)
        XCTAssertEqual(day, 6, "Day returned is not the 6th")
    }

    /**
    Method to test the appropriate suffix is attached to a day.
    */
    func testDaySuffix() {
    
        for index in 1...31 {
            if index == 1 || index == 21 || index == 31 {
                XCTAssertEqual(Utils.daySuffixFromDay(index), "\(index)st", "number did not return with an 'st' suffix")
            }
            else if index == 2 || index == 22 {
                XCTAssertEqual(Utils.daySuffixFromDay(index), "\(index)nd", "number did not return with an 'nd' suffix")
            }
            else if index == 3 || index == 23 {
                XCTAssertEqual(Utils.daySuffixFromDay(index), "\(index)rd", "number did not return with an 'rd' suffix")
            }
            else {
                XCTAssertEqual(Utils.daySuffixFromDay(index), "\(index)th", "number did not return with an 'th' suffix")
            }
    
        }
    
    }
    
    func testIntervalDateForUnit() {
        let dateOne = Utils.intervalDataForUnit("day")
        XCTAssertEqual(dateOne.hour, 1, "Hour interval should be equal to 1")
        
        let dateTwo = Utils.intervalDataForUnit("week")
        XCTAssertEqual(dateTwo.day, 1, "Day interval should be equal to 1")
    
        let dateThree = Utils.intervalDataForUnit("month")
        XCTAssertEqual(dateThree.day, 7, "Day interval should be equal to 7")
        
        let dateFour = Utils.intervalDataForUnit("year")
        XCTAssertEqual(dateFour.month, 1, "Month interval should be equal to 1")
    }
    
    func testPerformanceExample() {
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
   
}
