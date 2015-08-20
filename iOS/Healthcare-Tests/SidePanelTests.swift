/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import XCTest

/**
*  A unit test class for the SidePanelViewController.
*/
class SidePanelTests: XCTestCase {
    
    var vc: SidePanelViewController!
    
    override func setUp() {
        super.setUp()
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("LeftViewController") as! SidePanelViewController
        vc.loadView()
        
    }
    
    override func tearDown() {
        super.tearDown()
        vc = nil
    }
    
    /**
    Method verifies UITableView datasource protocol is working properly.
    */
    func testTableViewDatasource() {
        XCTAssertTrue(vc.conformsToProtocol(UITableViewDataSource), "View does not conform to UITableView datasource protocol")
        XCTAssertNotNil(vc.menuTableView.dataSource, "TableView datasource is nil")
    }
    
    /**
    Method verifies UITableView delegate protocol is working properly.
    */
    func testTableViewDelegate() {
        XCTAssertTrue(vc.conformsToProtocol(UITableViewDelegate), "View does not conform to UITableView delegate protocol")
        XCTAssertNotNil(vc.menuTableView.delegate, "TableView delegate is nil")
    }
    
    /**
    This method verifies the UITableView has the correct amount of rows.
    */
    func testTableViewNumberOfRows() {
        var expectedNumber = 6
        XCTAssertTrue(vc.tableView(vc.menuTableView, numberOfRowsInSection: 0) == expectedNumber, "TableView has \(vc.tableView(vc.menuTableView, numberOfRowsInSection: 0)) rows, but it should have \(expectedNumber)")
    }
    
    /**
    Method to ensure row height in UITableView is correct.
    */
    func testTableViewCellHeight() {
        var expectedHeight = (vc.view.frame.size.height/2)/6
        for index in 0...6 {
            var actualHeight = vc.tableView(vc.menuTableView, heightForRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
            XCTAssertEqual(expectedHeight, actualHeight, "Cell should have height of \(expectedHeight), but they have a height of \(actualHeight)")
        }
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
}
