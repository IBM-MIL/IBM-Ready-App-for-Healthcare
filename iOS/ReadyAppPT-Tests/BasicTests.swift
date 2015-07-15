/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

/*
A suite of basic tests to demonstrate how to unit test on the iOS platform. The tests depend on
the BasicFunctions class, which must enable ReadyAppPT-Tests in its target membership in order
to be accessible from the testing framework.

For a good article on iOS unit testing, read http://nshipster.com/xctestcase/
*/

import UIKit
import XCTest

class SampleTestingProjectTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFibonacci() {
        XCTAssertEqual(fib(5), 8, "fib(5) = 8")
    }
    
    func testFactorial() {
        XCTAssertEqual(fac(5), 120, "fac(5) = 120")
    }
    
    func testBinaryTreeSum() {
        var tree = BinaryTree(val: 5, left: BinaryTree(val: 3, left: nil, right: nil), right: BinaryTree(val: 4, left: nil, right: nil))
        XCTAssertEqual(BinaryTree.computeSum(tree), 12, "sum of binary tree with nodes 3, 4, 5 should be 12")
    }
    
}
