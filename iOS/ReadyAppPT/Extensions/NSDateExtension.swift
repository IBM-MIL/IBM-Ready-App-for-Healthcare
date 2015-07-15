/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation

extension NSDate {
    
    func dateOffset() -> NSDate {
        return self.dateByAddingTimeInterval(-1 * 60)
    }
    
    /**
    Utility method to get date 2 days ago from caller's date.
    Hours offset by 1 to get 48 data points with HealthKit, for example:
    self = 11/20 4pm, return value = 11/17 5pm
    
    :returns: NSDate from 48 hours ago
    */
    func dateTwoDaysAgo() -> NSDate {
        return self.dateByAddingTimeInterval(-1 * 48 * 60 * 60)
    }
    
    /**
    Utility method to get date 1 week ago from caller's date.
    
    :returns: NSDate from 7 days ago
    */
    func dateOneWeeksAgo() -> NSDate {
        return self.dateByAddingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    /**
    Utility method to get date 2 weeks ago from caller's date.
    
    :returns: NSDate from 14 days ago
    */
    func dateTwoWeeksAgo() -> NSDate {
        return self.dateByAddingTimeInterval(-14 * 24 * 60 * 60)
    }
    
    /**
    Utility method to give accurate date for 2 months (56 days) from caller's date
    
    :returns: NSDate from 2 months (56 days) month ago
    */
    func dateTwoMonthsAgo() -> NSDate {
        return self.dateByAddingTimeInterval(-56 * 24 * 60 * 60)
    }
    
    /**
    Utility method to give accurate date for 2 years ago from caller's date
    
    :returns: NSDate from 2 years ago
    */
    func dateTwoYearsAgo() -> NSDate {
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var offsetComponents = NSDateComponents()
        offsetComponents.year = -2
        var previousYear = calendar?.dateByAddingComponents(offsetComponents, toDate: self, options: nil)
        return previousYear!
    }
}