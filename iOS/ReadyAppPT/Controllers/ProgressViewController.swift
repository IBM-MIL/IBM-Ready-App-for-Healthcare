/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import HealthKit
import CoreData

/**
ProgressViewController presents all metric related data and progress for a particular user in day, week, or month.
*/
class ProgressViewController: MILWebViewController, MILWebViewDelegate {
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var viewType: String?
    var todaysDate: NSDate = NSDate()
    var timeUnit = ""
    var formattedDate = ""
    var currentGoal = 0 // substitute with server data if desired
    var format = ".0"
    var isCalorieData = false
    // dataLock is used to prevent multiple injections from happening at the same time
    var dataLock = (metaString: "", performanceString: "", graphString: "")
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    /// lazy loading access to the managedObjectContext for the app, originally created in AppDelegate
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
            return nil
        }
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        self.startPage = "index.html/WebView/" + viewType!
        
        super.viewDidLoad()
        
        Utils.rootViewMenu(self.parentViewController!, disablePanning: true)
        self.webView.scrollView.scrollEnabled = false
        self.delegate = self
        self.setupWebViewConstraints()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Method to simply pop the current view controller
    */
    @IBAction func popViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Method to simply open the side panel
    */
    func openSideMenu() {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.webView.userInteractionEnabled = false
        tapGestureRecognizer.enabled = true
    }
    
    /**
    Method to handle taps when the side menu is open
    
    - parameter recognizer: tap gesture used to call method
    */
    func handleTap(recognizer: UITapGestureRecognizer) {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        // check if expanded so tapgesture isn't enabled when it shouldn't be
        if container.currentState == SlideOutState.LeftExpanded {
            container.toggleLeftPanel()
            self.webView.userInteractionEnabled = true
            tapGestureRecognizer.enabled = false
        } else {
            self.webView.userInteractionEnabled = true
            tapGestureRecognizer.enabled = false
        }
    }
    
    /**
    Simple syntax method to delay execution of some code
    
    - parameter delay:   amount of delay in seconds
    - parameter closure: Code to be executed after delay, on main thread
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: MILWebViewDelegate method
    
    /**
    Method to inform view that the webview content has changed, thus, take the appropriate actions
    
    - parameter pathComponents: array of strings represnting what the webView route has changed to
    */
    func webViewHasChanged(pathComponents: Array<String>) {
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Gradient)
        let surrenderRoute = Utils.prepareCodeInjectionString("surrenderRouteControl();")
        self.webView.stringByEvaluatingJavaScriptFromString(surrenderRoute)
        let localeLoad = Utils.prepareCodeInjectionString("setLanguage('\(NSLocale.currentLocale().localeIdentifier)')")
        self.webView.stringByEvaluatingJavaScriptFromString(localeLoad)

        // Put data in easily comparable formats
        var lastElement = pathComponents.last
        let items = (lastElement!).characters.split(Int.max, allowEmptySlices: false, isSeparator: { $0 == "_" }).map { String($0) }

        // determine the time unit for which to collect data in.
        if var _ = items.indexOf("year") {
            timeUnit = "year"
        } else if var _ = items.indexOf("week") {
            timeUnit = "week"
        } else if var _ = items.indexOf("month") {
            timeUnit = "month"
        } else {
            timeUnit = "day"
        }
        
        // Set goal and call population method for selected view
        if items.count <= 2 {

            if lastElement == "metrics_steps" {
                self.currentGoal = DataManager.dataManager.currentPatient.stepGoal.integerValue
                populateIndividualView(HKQuantityTypeIdentifierStepCount)
                
            } else if lastElement == "metrics_hr" {
                self.currentGoal = 70
                populateIndividualView(HKQuantityTypeIdentifierHeartRate)
                
            } else if lastElement == "metrics_calories" {
                self.currentGoal = DataManager.dataManager.currentPatient.calorieGoal.integerValue
                populateIndividualView(HKQuantityTypeIdentifierActiveEnergyBurned)
                
            } else if lastElement == "metrics_weight" {
                self.currentGoal = 175
                populateIndividualView(HKQuantityTypeIdentifierBodyMass)
                
            } else if lastElement == "metrics_pain" {
                populateIndividualView("painData")
            } else {
                populateAllGraphs()
                
            }
        } else if items.count == 3 {
            
            if var _ = items.indexOf("steps") {
                self.currentGoal = DataManager.dataManager.currentPatient.stepGoal.integerValue
                populateIndividualView(HKQuantityTypeIdentifierStepCount)
                
            } else if var _ = items.indexOf("hr") {
                self.currentGoal = 70
                populateIndividualView(HKQuantityTypeIdentifierHeartRate)
                
            } else if var _ = items.indexOf("calories") {
                self.currentGoal = DataManager.dataManager.currentPatient.calorieGoal.integerValue
                populateIndividualView(HKQuantityTypeIdentifierActiveEnergyBurned)
                
            } else if var _ = items.indexOf("weight") {
                self.currentGoal = 175
                populateIndividualView(HKQuantityTypeIdentifierBodyMass)
                
            } else {
                populateIndividualView("painData")
            }
        }
    }
    
    // MARK: Metrics and graph data population
    
    /**
    Method to collect and format data for the all metrics view.
    This includes weight, heart rate, calories, steps, and pain report ratings.
    We only do one data injection for a smooth view load
    */
    func populateAllGraphs() {
        var startDate: NSDate?, endDate: NSDate?
        if timeUnit == "day" {
            startDate = todaysDate.dateTwoDaysAgo()
            endDate = todaysDate.dateOffset()
        } else if timeUnit == "week" {
            startDate = todaysDate.dateTwoWeeksAgo()
            endDate = todaysDate.dateOffset()
        } else if timeUnit == "month" {
            startDate = todaysDate.dateTwoMonthsAgo()
            endDate = todaysDate.dateOffset()
        } else {
            startDate = todaysDate.dateTwoYearsAgo()
            endDate = todaysDate.dateOffset()
        }
        
        var weightJson = ""
        var heartJson = ""
        var calorieJson = ""
        var stepJson = ""
        var painJson = ""
        
        let heartType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        let intervalData = Utils.intervalDataForUnit(timeUnit)
        HealthKitManager.healthKitManager.getAverageDataInRange(startDate!, end: endDate!, interval: intervalData, type: heartType, callback: {(json) in
            self.delay(0.0, closure: {
                heartJson = json
                if weightJson != "" && stepJson != "" && calorieJson != "" && painJson != "" {
                    SVProgressHUD.dismiss()
                    let jsonInjection = Utils.prepareGraphInjectionString("applyData(['\(heartJson)','\(weightJson)','\(stepJson)','\(calorieJson)','\(painJson)']);")
                    self.webView.stringByEvaluatingJavaScriptFromString(jsonInjection)
                    
                    let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
                    self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
                }

            })
        })
        
       let weightType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        HealthKitManager.healthKitManager.getAverageDataInRange(startDate!, end: endDate!, interval: intervalData, type: weightType, callback: {(json) in
            self.delay(0.0, closure: {
                weightJson = json
                if heartJson != "" && stepJson != "" && calorieJson != "" && painJson != "" {
                    SVProgressHUD.dismiss()
                    let jsonInjection = Utils.prepareGraphInjectionString("applyData(['\(heartJson)','\(weightJson)','\(stepJson)','\(calorieJson)','\(painJson)']);")
                    self.webView.stringByEvaluatingJavaScriptFromString(jsonInjection)
                    
                    let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
                    self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
                }
            })
        })
        
        let calorieType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        HealthKitManager.healthKitManager.getSumDataInRange(startDate!, end: endDate!, interval: intervalData, type: calorieType, callback: {(json) in
            self.delay(0.0, closure: {
                calorieJson = json
                if weightJson != "" && stepJson != "" && heartJson != "" && painJson != "" {
                    SVProgressHUD.dismiss()
                    let jsonInjection = Utils.prepareGraphInjectionString("applyData(['\(heartJson)','\(weightJson)','\(stepJson)','\(calorieJson)','\(painJson)']);")
                    self.webView.stringByEvaluatingJavaScriptFromString(jsonInjection)
                    
                    let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
                    self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
                }
            })
        })
        
        let stepType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
        HealthKitManager.healthKitManager.getSumDataInRange(startDate!, end: endDate!, interval: intervalData, type: stepType, callback: { (json) in
            self.delay(0.0, closure: {
                stepJson = json
                if weightJson != "" && heartJson != "" && calorieJson != "" && painJson != "" {
                    SVProgressHUD.dismiss()
                    let jsonInjection = Utils.prepareGraphInjectionString("applyData(['\(heartJson)','\(weightJson)','\(stepJson)','\(calorieJson)','\(painJson)']);")
                    self.webView.stringByEvaluatingJavaScriptFromString(jsonInjection)
                    
                    let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
                    self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
                }
            })
        })

        let painData = PainData.fetchDataInRange(self.managedObjectContext!, start: startDate!, end: todaysDate, dateComps: intervalData, timeUnit: timeUnit)
        painJson = painData.json
        if heartJson != "" && stepJson != "" && calorieJson != "" && weightJson != "" {
            SVProgressHUD.dismiss()
            let jsonInjection = Utils.prepareGraphInjectionString("applyData(['\(heartJson)','\(weightJson)','\(stepJson)','\(calorieJson)','\(painJson)']);")
            self.webView.stringByEvaluatingJavaScriptFromString(jsonInjection)
            
            let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
            self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
        }
        
    }
    
    /**
    Helper method that deals with populating all the relevant data in each individual metric view
    */
    func populateIndividualView(type: String) {
        var startDate: NSDate?, endDate: NSDate?
        let intervalData = Utils.intervalDataForUnit(timeUnit)
        dataLock = ("", "", "")
        
        /* Calculate the correct date range and display current date range */
        if timeUnit == "day" {
            let localizedDate = Utils.localizedMonthDay(todaysDate, dateStyle: NSDateFormatterStyle.LongStyle)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh a"
            let timeString = formatter.stringFromDate(todaysDate)
            formattedDate = localizedDate + " - " + timeString
            
            startDate = todaysDate.dateTwoDaysAgo()
            endDate = todaysDate.dateOffset()
            
        } else if timeUnit == "week" {
            let localizedDate = Utils.localizedMonthDay(todaysDate, dateStyle: NSDateFormatterStyle.LongStyle)
            formattedDate = localizedDate
            
            startDate = todaysDate.dateTwoWeeksAgo()
            endDate = todaysDate.dateOffset()
            
            // Calculates goal if applicable
            if type == HKQuantityTypeIdentifierStepCount || type == HKQuantityTypeIdentifierActiveEnergyBurned {
                self.currentGoal *= 7
            }
            
        } else if timeUnit == "month" {
            let beginDay = Utils.localizedMonthDay(todaysDate.dateOneWeeksAgo(), dateStyle: NSDateFormatterStyle.MediumStyle)
            let endDay = Utils.localizedMonthDay(todaysDate, dateStyle: NSDateFormatterStyle.MediumStyle)
            formattedDate = "\(beginDay) - \(endDay)"
            
            
            startDate = todaysDate.dateTwoMonthsAgo()
            endDate = todaysDate.dateOffset()
            
            if type == HKQuantityTypeIdentifierStepCount || type == HKQuantityTypeIdentifierActiveEnergyBurned { self.currentGoal *= 30 }
            
        } else {
            let month = Utils.extractMonthNameFromDate(todaysDate)
            let year = Utils.extractYearFromDate(todaysDate)
            formattedDate = "\(month) \(year)"
            
            startDate = todaysDate.dateTwoYearsAgo()
            endDate = todaysDate.dateOffset()
            
            if type == HKQuantityTypeIdentifierStepCount || type == HKQuantityTypeIdentifierActiveEnergyBurned { self.currentGoal *= 365 }
           
        }
        
        /* Collect pain data and inject into webView if selected */
        if type == "painData" {
            let painData = PainData.fetchDataInRange(self.managedObjectContext!, start: startDate!, end: todaysDate, dateComps: intervalData, timeUnit: timeUnit)
            
            self.currentGoal = 2
            let error: NSError? = nil
            injectSumMetricData((painData.average as NSString).doubleValue, error: error)
            
            dataLock.graphString = Utils.prepareGraphInjectionString("applyData(['\(painData.json)']);")
            if dataLock.graphString != "" && dataLock.metaString != "" && dataLock.performanceString != "" {
                self.resumeFromDataInjection()
            }
            
            return
        }
       
        /* Collect data for other individual metrics based on type */
        
        // Populate the graph for an individual metric
        let hkType: HKQuantityType = HKObjectType.quantityTypeForIdentifier(type)!
        
        if type == HKQuantityTypeIdentifierStepCount || type == HKQuantityTypeIdentifierActiveEnergyBurned {
            
            // Gather total data for metric
            if type == HKQuantityTypeIdentifierStepCount {
                isCalorieData = false
                HealthKitManager.healthKitManager.getSteps(startDate!, callback: injectSumMetricData)
            } else {
                isCalorieData = true
                HealthKitManager.healthKitManager.getCaloriesBurned(startDate!, callback: injectSumMetricData)
            }
            
            // Get graph data to inject
            HealthKitManager.healthKitManager.getSumDataInRange(startDate!, end: endDate!, interval: intervalData, type: hkType, callback: { (json) in
                self.delay(0.0, closure: {
                    
                    self.dataLock.graphString = Utils.prepareGraphInjectionString("applyData(['\(json)']);")
                    if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                        self.resumeFromDataInjection()
                    }
                })
            })
            
        } else {
            
            // Gather total data for metric
            if type == HKQuantityTypeIdentifierHeartRate {

                // Placing heart rate method call here because of specific accessors like .Average
                HealthKitManager.healthKitManager.getHeartRateData(startDate!, callback: { (data, err) in
                    if err == nil {
                        self.delay(0.0, closure: {
                            if data != nil{
                                if let val = data[HeartRateData.Average.rawValue] {
                                    self.dataLock.performanceString = Utils.prepareCodeInjectionString("setPerformance(\(val.format(self.format)))")
                                }
                            } else {
                                let val: Double = 0
                                self.dataLock.performanceString = Utils.prepareCodeInjectionString("setPerformance(\(val.format(self.format)))")
                            }
                            
                            if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                                self.resumeFromDataInjection()
                            }
                        })
                    }
                })
                
                self.delay(0.0, closure: {
                    let dateUnit = Utils.prepareCodeInjectionString("setUnit('\(Utils.unitLabelFor(self.timeUnit))')")
                    let date = Utils.prepareCodeInjectionString("setTimeFrame('\(self.formattedDate)')")
                    
                    self.dataLock.metaString = date + dateUnit
                    if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                        self.resumeFromDataInjection()
                    }
                })
                
            } else {

                // Placing weight method call here because of specific accessors like .Current
                HealthKitManager.healthKitManager.getWeightInPoundsData(startDate!, callback: { (data, err) in
                    if err == nil {
                        self.delay(0.0, closure: {
                            if data != nil {
                                if let val = data[WeightInPoundsData.Current.rawValue] {

                                    let localizedWeight = Utils.getLocalizedWeight(val)
                                    self.dataLock.performanceString = Utils.prepareCodeInjectionString("setPerformance('\(localizedWeight)')")
                                }
                                
                            } else {
                                let val: Double = 0
                                self.dataLock.performanceString = Utils.prepareCodeInjectionString("setPerformance(\(val.format(self.format)))")
    
                            }
                            
                            if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                                self.resumeFromDataInjection()
                            }
                        })
                        
                    }
                })
                
                self.delay(0.0, closure: {
                    let dateUnit = Utils.prepareCodeInjectionString("setUnit('\(Utils.unitLabelFor(self.timeUnit))')")
                    let date = Utils.prepareCodeInjectionString("setTimeFrame('\(self.formattedDate)')")
                    
                    self.dataLock.metaString = dateUnit + date
                    if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                        self.resumeFromDataInjection()
                    }
                })
            }
            
            // Get graph data to inject
            HealthKitManager.healthKitManager.getAverageDataInRange(startDate!, end: endDate!, interval: intervalData, type: hkType, callback: {(json) in
                self.delay(0.0, closure: {
                    
                    self.dataLock.graphString = Utils.prepareGraphInjectionString("applyData(['\(json)']);")
                    if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                        self.resumeFromDataInjection()
                    }
                })
            })
            
        }
    }
    
    /**
    Callback method to inject data into individual metric view categories
    
    - parameter result: value returned from healthkit method
    - parameter error:  error value if any
    */
    func injectSumMetricData(result: Double, error: NSError?) {
        if error == nil{
            self.delay(0.4, closure: {
                var finalResult = result.format(self.format)
                if self.isCalorieData {
                    finalResult = Utils.getLocalizedEnergy(result)
                }
                self.dataLock.performanceString = Utils.prepareCodeInjectionString("setPerformance(\(finalResult))")
                let dateUnit = Utils.prepareCodeInjectionString("setUnit('\(Utils.unitLabelFor(self.timeUnit))')")
                let date = Utils.prepareCodeInjectionString("setTimeFrame('\(self.formattedDate)')")
                let metricGoal = Utils.prepareCodeInjectionString("setGoal(\(self.currentGoal))")
                self.dataLock.metaString = date + dateUnit + metricGoal
                
                if self.dataLock.graphString != "" && self.dataLock.metaString != "" && self.dataLock.performanceString != "" {
                    self.resumeFromDataInjection()
                }
            })
        }
        
    }
    
    /**
    Method that dismisses loading HUD and sets hybrid view to be ready for more user input.
    */
    func resumeFromDataInjection() {
        SVProgressHUD.dismiss()
        self.webView.stringByEvaluatingJavaScriptFromString(self.dataLock.metaString + self.dataLock.performanceString + self.dataLock.graphString)
        
        let resumeRoute = Utils.prepareCodeInjectionString("resumeRouteControl();")
        self.webView.stringByEvaluatingJavaScriptFromString(resumeRoute)
    }

}
