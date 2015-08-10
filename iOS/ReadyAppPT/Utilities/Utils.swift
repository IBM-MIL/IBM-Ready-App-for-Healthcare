/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import Foundation
import HealthKit

/**
*  Utility class primarily for formatting data to be sent to a hyrbrid view.
*/
class Utils {
    
    /**
    This method creates a short angular script to alter data in a hybrid view
    
    - parameter functionCall: the function to be called in the javascript with arguments included in the string
    
    - returns: a clean script to inject into the javascript
    */
    class func prepareCodeInjectionString(functionCall: String) -> String {
        return "setTimeout(function() {  var scope = angular.element(document.getElementById('scope')).scope(); scope.$apply(function() { scope." + functionCall + "}); }, 50);"
    }
    
    /**
    This method creates a short angular script to alter data for a d3 graph
    
    - parameter json: the json array in string form
    
    - returns: a clean script to inject into the javascript
    */
    class func prepareGraphInjectionString(json: String) -> String {
        return "setTimeout(function() {   var scope = angular.element(document.getElementById('scope')).scope();\nscope." + json + " }, 50);"
    }
    
    /**
    Helper method to convert an AnyObject to a Json string.
    Primarily used to convert and array of dictionaries to json.
    
    - parameter value:         the value to be converted
    - parameter prettyPrinted: used to set pretty print out options
    
    - returns: String of Json
    */
    class func JSONStringify(value: AnyObject, prettyPrinted: Bool) -> String {
        let options: NSJSONWritingOptions = NSJSONWritingOptions.PrettyPrinted // Seems to be only option
        if NSJSONSerialization.isValidJSONObject(value) {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            } catch _ {
            }
        }
        return ""
    }
    
    /**
    This method prefixes any single-digit number with zero.
    
    - parameter number: The number to format if necessary
    
    - returns: the formatted number
    */
    class func formatSingleDigits(number: Int) -> String {
        if number < 10 {
            return NSString(format: "0%d", number) as String
        } else {
            return "\(number)"
        }
    }
    
    /**
    Method to grab the current year from the local device based on parameter date
    
    - parameter date: the date to get the year for
    
    - returns: Int of the current year
    */
    class func extractYearFromDate(date: NSDate) -> Int {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date)
        return components.year
    }
    
    /**
    Method to grab the current month name from local device (e.g. April, November)
    
    - parameter date: The current date in a numerical format
    
    - returns: The current month name
    */
    class func extractMonthNameFromDate(date: NSDate) -> String {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date)
        let df = NSDateFormatter()
        return df.monthSymbols[components.month - 1] 
    }
    
    /**
    Method to grab the current day number from local device
    
    - parameter date: The current date in a numerical format
    
    - returns: The current day digit
    */
    class func extractDayFromDate(date: NSDate) -> Int {
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date)
        return components.day
    }
    
    /**
    This method adds the appropriate ordinal day suffix
    NOTE: this only works for english dates, individual language number suffixes will need to be supported separately
    
    - parameter day: This is the number representing day in the month
    
    - returns: String with suffix attached to numerical day
    */
    class func daySuffixFromDay(day: Int) -> String {
        switch (day) {
        case 1, 21, 31: return "\(day)st"
        case 2, 22:     return "\(day)nd"
        case 3, 23:     return "\(day)rd"
        default:        return "\(day)th"
        }
    }
    
    /**
    Method to get a localized version of the date in a month day format, for example: December 12
    
    - parameter date: the date to find the information for.
    
    - returns: localized string with the desired date
    */
    class func localizedMonthDay(date: NSDate, dateStyle: NSDateFormatterStyle) -> String {
        
        var localizedDate = NSDateFormatter.localizedStringFromDate(date, dateStyle: dateStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        var pieces = localizedDate.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        
        if NSLocale.currentLocale().localeIdentifier == "en_US" || NSLocale.currentLocale().localeIdentifier == "en" {
            var day = pieces[1] as NSString
            day = day.stringByReplacingOccurrencesOfString(",", withString: "")
            pieces[1] = day as String
        }
        
        if pieces.count >= 2 {
            let year = "\(Utils.extractYearFromDate(date))"
            if let index = pieces.indexOf(year) {
                pieces.removeAtIndex(index)
            }
            let finalString = " ".join(pieces)
            return finalString
        } else {
            return "\(pieces.first!)"
        }
    }
    
    /**
    Method to simply get the correct description of the current date based on day, week, month, or year.
    
    - parameter unit: the unit by which data has been gathered for
    
    - returns: String with time unit description
    */
    class func unitLabelFor(unit: String) -> String {

        switch (unit) {
        case "day":
            return NSLocalizedString("Today", comment: "n/a")
        case "week":
            return NSLocalizedString("Today", comment: "n/a")
        case "month":
            return NSLocalizedString("This Week", comment: "n/a")
        case "year":
            return NSLocalizedString("This Month", comment: "n/a")
        default: return ""
        }
    }
    
    /**
    Method to return relevant interval data for healthkit based on time unit.
    
    - parameter unit: time unit suchas as Day, Week, Year.
    
    - returns: NSDateComponents with interval data that should be used to iterate through
    */
    class func intervalDataForUnit(unit: String) -> NSDateComponents {
        let intervalComponents = NSDateComponents()
        switch (unit) {
        case "day":
            intervalComponents.hour = 1
            return intervalComponents
        case "week":
            intervalComponents.day = 1
            return intervalComponents
        case "month":
            intervalComponents.day = 7
            return intervalComponents
        case "year":
            intervalComponents.month = 1
            return intervalComponents
        default: return intervalComponents
        }
    }
    
    /**
    This method checks if parent is a navigationController with only one object.
    It then, sets a side menu button for opening and closing.
    
    - parameter parentVC:       the parent view controller of caller
    - parameter disablePanning: determines if panning should be disabled also
    */
    class func rootViewMenu(parentVC: AnyObject, disablePanning: Bool) {
        
        if parentVC.isKindOfClass(UINavigationController.self) {
            let nav = parentVC as! UINavigationController
            if nav.viewControllers.count == 1 {
                
                let childVC: AnyObject? = nav.childViewControllers.first
                let menuIcon = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: childVC, action: "openSideMenu" )
                menuIcon.tintColor = UIColor.whiteColor()
                childVC?.navigationItem.leftBarButtonItem = menuIcon
                
                if disablePanning {
                    let container = nav.parentViewController as! ContainerViewController
                    container.togglePanGesture(false)
                }
            }
        }
    }
    
    /**
    Method that accesses the root container and calls another method to return to the dashboard
    */
    class func returnToDashboard() {
        let presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController
        if let presented = presentedVC {
            if let containerVC = presented as? ContainerViewController {
                containerVC.popAndReturnHome()
            }
        }
    }
    
    class func getRoutines(worklightResponseJson: NSDictionary) -> [Routine]{
        var routines : [Routine] = []
        
        let jsonResultArray = worklightResponseJson["result"] as! NSArray
        
        for jsonResult in jsonResultArray{
            let routine = Routine()
            routine.id = jsonResult["_id"] as! String
            routine.routineTitle = jsonResult["routineTitle"] as! String
            let exerciseArray = jsonResult["exercises"] as! NSArray
            print("\(exerciseArray)")
            // routine.exercises = jsonResult["exercises"] as! NSArray
            routines.append(routine)
        }
        return routines
    }
    
    class func getExercisesforRoutine(worklightResponseJson: NSDictionary) -> [Exercise]{
        var exercises : [Exercise] = []
        
        let jsonResultArray = worklightResponseJson["result"] as! NSArray
        
        for jsonResult in jsonResultArray {
            print("Result: \(jsonResult)")
            let exercise = Exercise()
            exercise.id = jsonResult["_id"] as! String
            print(jsonResult["exerciseTitle"])
            exercise.exerciseTitle = jsonResult["exerciseTitle"] as! String
            exercise.exerciseDescription = jsonResult["description"] as! String!
            exercise.minutes = jsonResult["minutes"] as! NSNumber
            exercise.repetitions = jsonResult["repetitions"] as! NSNumber
            exercise.sets = jsonResult["sets"] as! NSNumber
            exercise.videoURL = jsonResult["url"] as! String
            exercise.tools = jsonResult["tools"] as! String
            exercises.append(exercise)
        }
        return exercises
    }
    
    class func getQuestionnaireForUser(worklightResponseJson: NSDictionary) -> [Forms]{
        var forms : [Forms] = []
        
        let jsonResultArray = worklightResponseJson["result"] as! NSArray
        
        for jsonResult in jsonResultArray{
            let form = Forms()
            form.id = jsonResult["_id"] as! String
            form.textDescription = jsonResult["text"] as! String
            form.type = jsonResult["type"] as! String!
            forms.append(form)
        }
        return forms
    }
    
    /**
    Method to convert pounds weight to the appropriate locale metric
    
    - parameter value: the number of pounds to convert
    
    - returns: the converted weight measurement
    */
    class func getLocalizedWeight(value: Double) -> String {
        
        let massFormatter = NSMassFormatter()
        massFormatter.numberFormatter.maximumFractionDigits = 0
        massFormatter.forPersonMassUse = true
        let numFormat = HKQuantity(unit: HKUnit.poundUnit(), doubleValue: value)
        let kgWeight = numFormat.doubleValueForUnit(HKUnit(fromString: "kg"))
        var localizedMass = massFormatter.stringFromKilograms(kgWeight)
        var pieces = localizedMass.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        
        return pieces.first!
    }
    
    /**
    Simple method to grab the unit used to measure the converted weight
    
    - parameter value: number of joules to convert and grab unit from
    
    - returns: the chosen metric unit
    */
    class func getLocalizedWeightUnit(value: Double) -> String {
        let massFormatter = NSMassFormatter()
        massFormatter.forPersonMassUse = true
        let numFormat = HKQuantity(unit: HKUnit.poundUnit(), doubleValue: value)
        let kgWeight = numFormat.doubleValueForUnit(HKUnit(fromString: "kg"))
        var localizedMass = massFormatter.stringFromKilograms(kgWeight)
        var pieces = localizedMass.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        return pieces.last!
    }
    
    /**
    Method to convert joules to the appropriate locale metric
    
    - parameter value: number of joules to convert
    
    - returns: the converted energy metric
    */
    class func getLocalizedEnergy(value: Double) -> String {
        let energyFormatter = NSEnergyFormatter()
        energyFormatter.numberFormatter.maximumFractionDigits = 0
        
        // if less than 1 kcal, not signifigant
        if value < 1000 {
            return "0"
        }
        
        var localizedEnergyBurnt = energyFormatter.stringFromJoules(value)
        var pieces = localizedEnergyBurnt.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        
        // remove all characters that are not numbers
        let tempString = pieces.first!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let finalString = "".join(tempString)

        return finalString
    }
    
    /**
    Simple method to grab the unit used to measure the converted joules
    
    - parameter value: number of joules to convert and grab unit from
    
    - returns: the chosen metric unit
    */
    class func getLocalizedEnergyUnit(value: Double) -> String {
        let energyFormatter = NSEnergyFormatter()
        var localizedEnergyBurnt = energyFormatter.stringFromJoules(value)
        var pieces = localizedEnergyBurnt.characters.split(Int.max, allowEmptySlices: false, isSeparator: {$0 == " "}).map { String($0) }
        
        // some languages don't use spaces between value and unit, so we must parse the unit out.
        var finalString = pieces.last!
        if pieces.count < 2 {
            let tempString = pieces.first!.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet)
            finalString = "".join(tempString)
        }
        return finalString
    }
}