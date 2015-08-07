/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation
import CoreData

let painDataName = "PainData"

/**
Class representing the PainData entity in code from the core data model.
*/
class PainData: NSManagedObject {

    @NSManaged var painRating: NSNumber
    @NSManaged var painDescription: String
    @NSManaged var timeStamp: NSDate
    
    /**
    Helper method to easily create a new instance of PainData
    
    - parameter moc:         the managedObjectContext for the whole application
    - parameter rating:      the submitted pain rating from the user
    - parameter description: the description of the users pain
    
    - returns: PainData object reference of what was created
    */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, rating: Int, description: String) -> PainData {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(painDataName, inManagedObjectContext: moc) as! PainData
        newItem.painRating = rating
        newItem.painDescription = description
        newItem.timeStamp = NSDate()
        
        return newItem
    }
    
    /**
    This method saves data to persist through multiple app sessions
    
    - parameter moc: the managedObjectContext for the whole application
    */
    class func saveData(moc: NSManagedObjectContext) {
        var error: NSError?
        do {
            try moc.save()
            if error != nil {
                print(error?.localizedDescription)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    /**
    Method to simply log all the data currently in the PainData entity.
    
    - parameter moc: the managedObjectContext for the whole application
    */
    class func presentAllData(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: painDataName)
        if let fetchResults = moc.executeFetchRequest(fetchRequest) as? [PainData] {
            for result in fetchResults {
                print("desc: \(result.painDescription), rating: \(result.painRating), date: \(result.timeStamp)")
            }
            
            if fetchResults.count == 0 {
                print(NSLocalizedString("No data was found", comment: "n/a"))
            }
        }
    }
    
    /**
    Method for developer use to delete all data in the PainData entity.
    
    - parameter moc: the managedObjectContext for the whole application
    */
    class func deleteAllPainData(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: painDataName)
        if let fetchResults = moc.executeFetchRequest(fetchRequest) as? [PainData] {
            for result in fetchResults {
                moc.deleteObject(result)
                PainData.saveData(moc)
            }
        }
    }

    /**
    Method to grab data within date range at different points in that range and return in json
    
    - parameter moc:       the managedobjectcontext for the app
    - parameter start:     the start date range
    - parameter end:       the end date range
    - parameter dateComps: a date component used to calculate the interval
    - parameter timeUnit: identifies if we are looking at days, weeks, months, or years
    
    - returns: a string of Json
    */
    class func fetchDataInRange(moc: NSManagedObjectContext ,start: NSDate, end: NSDate, dateComps: NSDateComponents, timeUnit: String) -> (json: String, average: String) {
        var resultAverages: [AnyObject] = [AnyObject]()
        var jsonObject: [AnyObject] = [AnyObject]()
        var xValue: Int = 1
        let cal = NSCalendar.currentCalendar()
        var totalAverage = (0, 0)
        
        //Constants that determine how many data points for each time interval we need to generate
        let NUM_POINTS_DAY = 48
        let NUM_POINTS_WEEK = 14
        let NUM_POINTS_MONTH = 8
        let NUM_POINTS_YEAR = 24
        var num_points = 0
        
        if timeUnit == "day" {
            num_points = NUM_POINTS_DAY
            dateComps.hour = -1
        } else if timeUnit == "week" {
            num_points = NUM_POINTS_WEEK
            dateComps.day = -1
        } else if timeUnit == "month" {
            num_points = NUM_POINTS_MONTH
            dateComps.day = -7
        } else if timeUnit == "year" {
            num_points = NUM_POINTS_YEAR
            dateComps.year = -1
        }

        // Fetch all the data within range and then sort it out after
        let fetchRequest = NSFetchRequest(entityName: painDataName)
        let datePredicate = NSPredicate(format: "timeStamp > %@ AND timeStamp < %@", start, end)
        fetchRequest.predicate = datePredicate

        var error: NSError?
        if let results: [PainData] = moc.executeFetchRequest(fetchRequest) as? [PainData] {
            // iterate through dates
            var date: NSDate = end.copy() as! NSDate
            var previousDate = date
            while resultAverages.count < num_points {
                date = cal.dateByAddingComponents(dateComps, toDate: date, options: [])!
                var avg = 0
                var count = 0
                // find all dates in sub range and average them out before inserting into json
                for result in results {
                    let tempDate = result.timeStamp
                    if tempDate.timeIntervalSinceDate(previousDate) <= 0 && tempDate.timeIntervalSinceDate(date) >= 0 {
                        avg += result.painRating.integerValue
                        count++
                    }
                }
                
                if count > 0 {
                    avg = avg / count
                    
                    totalAverage.0 += avg
                    totalAverage.1++
                }
                
                resultAverages.append(avg)
                
                xValue++
                previousDate = date
            }
        }
        
        for (index, avg) in resultAverages.enumerate() {
            jsonObject.append(["x": resultAverages.count - index, "y":avg])
        }
        jsonObject = Array(jsonObject.reverse())
        let finalValue = totalAverage.1 == 0 ? "0" : "\(totalAverage.0 / totalAverage.1)"
        return (Utils.JSONStringify(jsonObject, prettyPrinted: false), finalValue)
    }
    
}
