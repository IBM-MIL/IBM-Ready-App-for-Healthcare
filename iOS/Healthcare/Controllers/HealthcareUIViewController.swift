/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation

/// Custom base viewController that all other view controllers should inherit from for Analytics tracking
class HealthcareUIViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        #if !Debug
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: NSStringFromClass(self.dynamicType))
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker.send(builder.build() as [NSObject : AnyObject])
        #endif
        
        super.viewWillAppear(animated)
    }
}