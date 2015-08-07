/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import HealthKit

/**
Enum for Types of HealthData. Used internally.

- HeartRate:
- StepCount:
- BodyMass:
- ActiveEnergyBurned:
*/
private enum HealthDataType {
    case HeartRate
    case StepCount
    case BodyMass
    case ActiveEnergyBurned
}

/**
Enums used as keys for the HeartRateData dictionary

- Min:     String key to access the minimum heart rate in a given time period
- Max:     String key to access the maximum heart rate in a given time period
- Average: String key to access the maximum heart rate in a given time period
*/
enum HeartRateData: String {
    case Min = "min"
    case Max = "max"
    case Average = "avg"
}

/**
Enums used as keys for the HeartRateData dictionary

- Start:   String key to access the weight at the beginning of time period
- Current: String key to access the weight at the end of time period
*/
enum WeightInPoundsData: String {
    case Start = "start"
    case Current = "current"
}

/**
Used to process and return specific data points from Health Kit
*/
class HealthKitManager: NSObject {
    var healthStore : HKHealthStore!
    var shouldPopulateHealthKit : Bool = false
    //Class variable that will return a singleton when requested
    class var healthKitManager : HealthKitManager{
        
        struct Singleton {
            static let instance = HealthKitManager()
        }
        return Singleton.instance
    }
    
    /**
    An override for the init method to insure the HKHealthStore is available
    */
    override init() {
        super.init()
        healthStore = HKHealthStore()
    }
    
    
    /**
    Populates HealthKit with data from the healthData.json file. This currently includes Heart Rate, Body Weight, Calories Burned, and Steps Taken data for 30 days previous to the current day.
    
    - parameter callback: Callback function. This will be triggered when the last HealthKit value is saved and will progress the app to the Dashboard.
    */
    func populateHealthKit(callback: (shouldProgress: Bool)->()) {
        
        // Get JSON data from the file
        let filePath = NSBundle.mainBundle().pathForResource("healthData", ofType: "json")
        let data = NSData(contentsOfFile: filePath!)
        let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
        let metrics = jsonResult["Metrics"] as! NSDictionary
        
        // Populate heart rate data
        let heartRateDict = metrics["HeartRate"] as! NSArray
        var rateType: HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let heartRateBPM = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
        for heartRatePoint in heartRateDict {
            let timeDiff = heartRatePoint["timeDiff"] as! String
            let heartRateValue = heartRatePoint["value"] as! String
            let timeDiffDouble = (timeDiff as NSString).doubleValue
            let heartRateDouble = (heartRateValue as NSString).doubleValue
            
            let rateQuantity = HKQuantity(unit: heartRateBPM, doubleValue: heartRateDouble)
            var date: NSDate = NSDate()
            date = date.dateByAddingTimeInterval(timeDiffDouble / -1000)
            
            let rateSample = HKQuantitySample(type: rateType, quantity: rateQuantity, startDate: date, endDate: date)
            healthStore.saveObject(rateSample, withCompletion: {(success:Bool, error: NSError?) -> Void in
                //println("healthkit save heart rate object = \(success) error = \(error)")
            })
        }
        
        // Populate body weight data
        let bodyWeightDict = metrics["BodyWeight"] as! NSArray
        rateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        for bodyWeightPoint in bodyWeightDict {
            let timeDiffString = bodyWeightPoint["timeDiff"] as! String
            let bodyWeightString = bodyWeightPoint["value"] as! String
            let timeDiff = (timeDiffString as NSString).doubleValue
            let bodyWeight = (bodyWeightString as NSString).doubleValue
            
            let rateQuantity = HKQuantity(unit: HKUnit.poundUnit(), doubleValue: bodyWeight)
            var date: NSDate = NSDate()
            date = date.dateByAddingTimeInterval(timeDiff / -1000)
            
            let rateSample = HKQuantitySample(type: rateType, quantity: rateQuantity, startDate: date, endDate: date)
            healthStore.saveObject(rateSample, withCompletion: {(success:Bool, error: NSError?) -> Void in
                //println("healthkit save body weight object = \(success) error = \(error)")
            })
        }
        
        // Populate calories data
        let caloriesDict = metrics["Calories"] as! NSArray
        rateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        for caloriesPoint in caloriesDict {
            let timeDiffString = caloriesPoint["timeDiff"] as! String
            let caloriesString = caloriesPoint["value"] as! String
            let timeDiff = (timeDiffString as NSString).doubleValue
            let calories = (caloriesString as NSString).doubleValue
            
            let rateQuantity = HKQuantity(unit: HKUnit.kilocalorieUnit() , doubleValue: calories)
            var date: NSDate = NSDate()
            date = date.dateByAddingTimeInterval(timeDiff / -1000)
            
            let rateSample = HKQuantitySample(type: rateType, quantity: rateQuantity, startDate: date, endDate: date)
            healthStore.saveObject(rateSample, withCompletion: {(success:Bool, error: NSError?) -> Void in
                //println("healthkit save calories object = \(success) error = \(error)")
            })
        }
        
        // Populate steps data
        let stepsDict = metrics["Steps"] as! NSArray
        rateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let totalStepsPoints = stepsDict.count
        var pointsCount = 0
        for stepsPoint in stepsDict {
            let timeDiffString = stepsPoint["timeDiff"] as! String
            let stepsString = stepsPoint["value"] as! String
            let timeDiff = (timeDiffString as NSString).doubleValue
            let steps = (stepsString as NSString).doubleValue
            
            let rateQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: steps)
            var date: NSDate = NSDate()
            date = date.dateByAddingTimeInterval(timeDiff / -1000)
            
            let rateSample = HKQuantitySample(type: rateType, quantity: rateQuantity, startDate: date, endDate: date)
            healthStore.saveObject(rateSample, withCompletion: {(success:Bool, error: NSError?) -> Void in
                pointsCount++
                if (pointsCount == totalStepsPoints) {
                    callback(shouldProgress: true)
                }
                //println("healthkit save steps object = \(success) error = \(error)")
            })
        }
    }
    
    /**
    Builds the set NSet of HKObjectTypes that are read from HealthKit
    
    - returns: NSet of HKObjectTypes
    */
    func getReadTypes() -> NSSet {
        
        //HeartRate
        let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        //StepCount
        let stepCountType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        //bodyMass
        let bodyMassType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        //EnergyBurned
        let energyBurnedType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        
        //Sex
        let sexType = HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)
        
        return NSSet(objects:heartRateType, stepCountType, bodyMassType, energyBurnedType, sexType)
    }
    
    /**
    Builds the set NSet of HKObjectTypes that are written to HealthKit
    
    - returns: NSet of HKObjectTypes
    */
    func getWriteTypes() -> NSSet {
        //HeartRate
        let heartRateType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        //StepCount
        let stepCountType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        //bodyMass
        let bodyMassType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        
        //EnergyBurned
        let energyBurnedType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        
        return NSSet(objects:heartRateType, stepCountType, bodyMassType, energyBurnedType)
    }
    
    /**
    Used to call the HealthKit permissions alert
    
    - parameter callback: callback function
    */
    func getPermissionsForHealthKit(callback: (shouldProgress: Bool)->()){
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (done, err) in
                if (self.shouldPopulateHealthKit) {
                    self.populateHealthKit(callback)
                } else {
                    callback(shouldProgress: done)
                }
            })
        }
    }
    
    func getHeartInRange() {
        var type: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
    }
    
    /**
    This method is bassed a callback which will be called with a dictionary containing the min, max, and average heart rates as well as an error for accessing HealthKit
    
    - parameter startDate: The beginning of the time period to query Health Kit
    - parameter callback:  callback function
    */
    func getHeartRateData(startDate: NSDate, callback: ([String: Double]!, NSError!) -> ()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
                    
                    let endDate = NSDate()
                    
                    let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.None)
                    
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.HeartRate), predicate: predicate, limit: Int.max, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                        
                        if(results == nil){
                            print("ERROR in getHeartRateData - data was nil")
                            return
                        }
                        
                        var data : [String : Double] = [:]
                        
                        var max = -9999.9
                        var min = 9999.9
                        var total = 0.0
                        let quantitySamples = results as! [HKQuantitySample]
                        for quantitySample in quantitySamples {
                            var value = quantitySample.quantity.doubleValueForUnit(HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit()))
                            if max < value {
                                max = value
                            }
                            if min > value {
                                min = value
                            }
                            total += value
                        }
                        
                        var average = 0.0
                        
                        if quantitySamples.count > 0 {
                            average = total / Double(quantitySamples.count)
                        }
                        
                        data[HeartRateData.Min.rawValue] = min
                        data[HeartRateData.Max.rawValue] = max
                        data[HeartRateData.Average.rawValue] = average
                        
                        if min == 9999.9 && max == -9999.9 && average == 0{
                            callback(nil, error)
                        }else{
                            callback(data, error)
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    This method is bassed a callback which will be called with a Double value of the total steps as well as an error for accessing HealthKit
    
    - parameter startDate: The beginning of the time period to query Health Kit
    - parameter callback:  callback function
    */
    func getSteps(startDate: NSDate, callback: (Double, NSError!) -> ()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
                    
                    let endDate = NSDate()
                    
                    let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.None)
                    
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.StepCount), predicate: predicate, limit: Int.max, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                        
                        var count = 0.0
                        
                        if let tempResults = results {
                            let quantitySamples = tempResults as! [HKQuantitySample]
                            for quantitySample in quantitySamples {
                                count += quantitySample.quantity.doubleValueForUnit(HKUnit.countUnit())
                            }
                            callback(count, error)
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    This method is bassed a callback which will be called with a dictionary containing the start and current weight as well as an error for accessing HealthKit
    
    - parameter startDate: The beginning of the time period to query Health Kit
    - parameter callback:  callback function
    */
    func getWeightInPoundsData(startDate: NSDate, callback: ([String: Double]!, NSError!) -> ()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
                    
                    let endDate = NSDate()
                    
                    let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.None)
                    
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.BodyMass), predicate: predicate, limit: Int.max, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                        
                        var data : [String : Double] = [:]
                        
                        if let quantitySamples = results as? [HKQuantitySample] {
                            if quantitySamples.count > 0 {
                                data[WeightInPoundsData.Start.rawValue] = quantitySamples.first?.quantity.doubleValueForUnit(HKUnit.poundUnit())
                                data[WeightInPoundsData.Current.rawValue] = quantitySamples.last?.quantity.doubleValueForUnit(HKUnit.poundUnit())
                            }
                            if data[WeightInPoundsData.Start.rawValue]  == nil && data[WeightInPoundsData.Current.rawValue]  == nil{
                                callback(nil, error)
                            }else{
                                callback(data, error)
                            }
                        } else {
                            callback(nil, error)
                        }
                        
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    This method is bassed a callback which will be called with a Double value of the total calories as well as an error for accessing HealthKit
    
    - parameter startDate: The beginning of the time period to query Health Kit
    - parameter callback:  callback function
    */
    func getCaloriesBurned(startDate: NSDate, callback: (Double, NSError!) -> ()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
                    
                    let endDate = NSDate()
                    
                    let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: HKQueryOptions.None)
                    
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.ActiveEnergyBurned), predicate: predicate, limit: Int.max, sortDescriptors: [timeSortDescriptor]) { (query, results, error) in
                        if (results != nil){
                            var count = 0.0
                            
                            let quantitySamples = results as! [HKQuantitySample]
                            for quantitySample in quantitySamples {
                                count += quantitySample.quantity.doubleValueForUnit(HKUnit.jouleUnit())
                            }
                            callback(count, error)
                        }else{
                            callback(0, error)
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    This method get the entered Sex of the user from healthkit to determine which vector graphic to display on the pain location page.
    
    - returns: A Boolean which is true if user is Male or Not Set, false if Female
    */
    func isMale() -> Bool {
        var sex: HKBiologicalSexObject = try! healthStore.biologicalSexWithError()
        if sex.biologicalSex == HKBiologicalSex.Female {
            return false
        } else {
            return true
        }
    }
    
    /**
    Internal function to get a specific HKSampleType
    
    - parameter type: Class enum
    
    - returns: The HKSampleType
    */
    private func getSampleTypeForEnum(type: HealthDataType) -> HKSampleType {
        
        switch(type){
        case HealthDataType.HeartRate:
            return HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        case HealthDataType.StepCount:
            return HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        case HealthDataType.BodyMass:
            return HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
        case HealthDataType.ActiveEnergyBurned:
            return HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        default:
            return HKSampleType()
        }
    }
    
    // MARK: HealthKit collection queries
    
    /**
    Method for a collection of HealthKit data that uses a Sum result
    
    - parameter start:         starting date range
    - parameter end:           ending date range
    - parameter interval:      date component representing how to separate data
    - parameter type:          type of HealthKit data to gather
    - parameter callback:      callback to report results to
    */
    func getSumDataInRange(start: NSDate, end: NSDate, interval: NSDateComponents, type: HKQuantityType, callback: (String) -> ()) {
        
        var jsonObject: [AnyObject] = [AnyObject]()
        var xValue: Int = 1
        
        var predicate = HKQuery.predicateForSamplesWithStartDate(start, endDate: end, options: HKQueryOptions.StrictEndDate)
        var query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: HKStatisticsOptions.CumulativeSum, anchorDate: start, intervalComponents: interval)
        
        query.initialResultsHandler = { (statsQuery: HKStatisticsCollectionQuery, collection: HKStatisticsCollection?, error: NSError?) in
            if collection != nil {
                collection.enumerateStatisticsFromDate(start, toDate: end, withBlock: { (result, stop) in
                    
                    if let sum: HKQuantity = result.sumQuantity() {

                        var sumUnit = ""
                        if type == self.getSampleTypeForEnum(HealthDataType.StepCount) as! HKQuantityType {
                            var temp = sum.doubleValueForUnit(HKUnit.countUnit())
                            temp = round(temp)
                            jsonObject.append(["x":xValue, "y":temp])
                        } else {
                            var temp = sum.doubleValueForUnit(HKUnit.jouleUnit())
                            temp = round(temp)
                            sumUnit = Utils.getLocalizedEnergy(temp)
                            jsonObject.append(["x":xValue, "y":sumUnit])
                        }
                        
                    } else {
                        jsonObject.append(["x":xValue, "y":0])
                    }
                    xValue++
                })
                callback(Utils.JSONStringify(jsonObject, prettyPrinted: false))
            }
        }
        HealthKitManager.healthKitManager.healthStore.executeQuery(query)
    }
    
    /**
    Method for a collection of HealthKit data that uses a Average result
    
    - parameter start:         starting date range
    - parameter end:           ending date range
    - parameter interval:      date component representing how to separate data
    - parameter type:          type of HealthKit data to gather
    - parameter callback:      callback to report results to
    */
    func getAverageDataInRange(start: NSDate, end: NSDate, interval: NSDateComponents, type: HKQuantityType, callback: (String) -> ()) {
        var jsonObject: [AnyObject] = [AnyObject]()
        var xValue: Int = 1
        
        var predicate = HKQuery.predicateForSamplesWithStartDate(start, endDate: end, options: HKQueryOptions.StrictEndDate)
        var query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: HKStatisticsOptions.DiscreteAverage, anchorDate: start, intervalComponents: interval)
        
        query.initialResultsHandler = { (statsQuery: HKStatisticsCollectionQuery, collection: HKStatisticsCollection?, error: NSError?) in
            if collection != nil {
                collection.enumerateStatisticsFromDate(start, toDate: end, withBlock: { (result, stop) in
                    if let avr: HKQuantity = result.averageQuantity() {
                        var avrUnit = ""
                        if type == self.getSampleTypeForEnum(HealthDataType.BodyMass) as! HKQuantityType {
                            var temp = avr.doubleValueForUnit(HKUnit.poundUnit())
                            temp = round(temp)
                            avrUnit = Utils.getLocalizedWeight(temp)
                            jsonObject.append(["x":xValue, "y":avrUnit])
                        } else {
                            var temp = avr.doubleValueForUnit(HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit()))
                            temp = round(temp)
                            jsonObject.append(["x":xValue, "y":temp])
                        }
                        
                    } else {
                        jsonObject.append(["x":xValue, "y":0])
                    }
                    xValue++
                })
                callback(Utils.JSONStringify(jsonObject, prettyPrinted: false))
            }
        }
        HealthKitManager.healthKitManager.healthStore.executeQuery(query)
    }
    
    /**
    Method for deleting all the HealthKit data created from the app
    
    - parameter callback:      callback to do something on completion
    */
    func deleteHealthKitData(callback: ()->()){
        self.deleteHeartRates({
            self.deleteSteps({
                self.deleteWeightData({
                    self.deleteCaloriesBurned({
                        callback()
                    })
                })
            })
        })
    }
    
    /**
    Method for deleting the Heart Rate data created from the app
    
    - parameter callback:      callback to do something on completion
    */
    func deleteHeartRates(callback: ()->()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.HeartRate), predicate: predicate, limit: Int.max, sortDescriptors: nil) { (query, results, error) in
                        
                        let quantitySamples = results as! [HKQuantitySample]
                        if quantitySamples.count > 0{
                            for (index, quantitySample) in quantitySamples.enumerate() {
                                self.healthStore.deleteObject(quantitySample, withCompletion: { (success, error) in
                                    if index == quantitySamples.count-1{
                                        callback()
                                    }
                                })
                            }
                        }else{
                            callback()
                        }
                    }
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    Method for deleting the Steps data created from the app
    
    - parameter callback:      callback to do something on completion
    */
    func deleteSteps(callback: ()->()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.StepCount), predicate: predicate, limit: Int.max, sortDescriptors: nil) { (query, results, error) in
                        
                        let quantitySamples = results as! [HKQuantitySample]
                        if quantitySamples.count > 0{
                            for (index, quantitySample) in quantitySamples.enumerate() {
                                self.healthStore.deleteObject(quantitySample, withCompletion: { (success, error) in
                                    if index == quantitySamples.count-1{
                                        callback()
                                    }
                                })
                            }
                        }else{
                            callback()
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    Method for deleting the Weight data created from the app
    
    - parameter callback:      callback to do something on completion
    */
    func deleteWeightData(callback: ()->()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.BodyMass), predicate: predicate, limit: Int.max, sortDescriptors: nil) { (query, results, error) in
                        
                        let quantitySamples = results as! [HKQuantitySample]
                        if quantitySamples.count > 0{
                            for (index, quantitySample) in quantitySamples.enumerate() {
                                self.healthStore.deleteObject(quantitySample, withCompletion: { (success, error) in
                                    if index == quantitySamples.count-1{
                                        callback()
                                    }
                                })
                            }
                        }else{
                            callback()
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
    /**
    Method for deleting the Calories Burned data created from the app
    
    - parameter callback:      callback to do something on completion
    */
    func deleteCaloriesBurned(callback: ()->()){
        
        let readTypes = self.getReadTypes()
        let writeTypes = self.getWriteTypes()
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorizationToShareTypes(writeTypes as Set<NSObject>, readTypes: readTypes as Set<NSObject>, completion: { (success, error) in
                if(success){
                    let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
                    
                    let query = HKSampleQuery(sampleType: self.getSampleTypeForEnum(HealthDataType.ActiveEnergyBurned), predicate: predicate, limit: Int.max, sortDescriptors: nil) { (query, results, error) in
                        
                        let quantitySamples = results as! [HKQuantitySample]
                        if quantitySamples.count > 0{
                            for (index, quantitySample) in quantitySamples.enumerate() {
                                self.healthStore.deleteObject(quantitySample, withCompletion: { (success, error) in
                                    if index == quantitySamples.count-1{
                                        callback()
                                    }
                                })
                            }
                        }else{
                            callback()
                        }
                    }
                    
                    self.healthStore.executeQuery(query)
                    
                }
            })
        }
    }
    
}
