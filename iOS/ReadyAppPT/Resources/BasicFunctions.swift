/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
(a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product,
either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's
own products.
*/

// This file contains some basic functions (and a simple class) that are used to demonstrate the iOS platform's
// unit testing capibilities. These methods are just for reference are not necessary for the app to work.

import Foundation

// computes the nth value of the fibonacci sequence
func fib(n: Int) -> Int {
    if n < 2 {
        return 1
    } else {
        return fib(n - 1) + fib(n - 2)
    }
}

// computes n! (n * n-1 * ... * 1)
func fac(n: Int) -> Int {
    if n == 0 {
        return 1
    } else {
        return n * fac(n - 1)
    }
}

// Binary tree implementation used for testing
class BinaryTree {
    let val: Int
    let left: BinaryTree?
    let right: BinaryTree?
    
    init(val: Int, left: BinaryTree?, right: BinaryTree?) {
        self.val = val
        self.left = left
        self.right = right
    }
    
    // recursively computes the sum of a binary tree
    class func computeSum(tree: BinaryTree?) -> Int {
        if tree == nil {
            return 0
        } else {
            return tree!.val + computeSum(tree!.left) + computeSum(tree!.right)
        }
    }
    
}
