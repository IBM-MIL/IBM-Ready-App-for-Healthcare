/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
    This view controller displays a vector graphic representation of a human body for the user to diagram
    where on their body they are feeling pain.  Once a body part (like an arm) is selected, the view zooms in
    and allows the user to place up to 5 specific pain pointers on that body part.
*/
class PainLocationViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, CustomAlertViewDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPointerButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var centerAddPointerConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingSpaceAddPointerConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceToDeleteConstraint: NSLayoutConstraint!
    var alertView: CustomAlertView!
    
    // Constants
    var MAX_ZOOM_SCALE: CGFloat = 3.0
    var MIN_ZOOM_SCALE: CGFloat = 1.0
    var PAIN_POINTER_WIDTH: CGFloat = 33.0
    var PAIN_POINTER_HEIGHT: CGFloat = 45.0
    var MAX_NUM_POINTERS: Int = 5
    var WIDTH_SCALE: CGFloat = 1.15
    
    // Booleans
    var isMale: Bool = true
    var zoomedIn: Bool = false
    var comingFromPainRating: Bool = false
    var useBlueColor: Bool = false
    
    // Vector image variables
    var imgView: SVGKLayeredImageView!
    var vectorWidth: CGFloat!
    var lastTappedLayer: CALayer?
    var originalFillColors: [CGColor] = []
    
    // Gesture recognizers
    var menuTapGestureRecognizer: UITapGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var previousTouchLocation: CGPoint = CGPoint(x: 0, y: 0)        //Used for calcuating offsets when panning

    // Variables for when zoomed into the body
    var saveLeadingConstaintValue: CGFloat = 0
    var currentPointer: UIImageView!
    var painPointers: [UIImageView] = []
    
    /**
    Setup variables, gesture recognizers, constraints, etc.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.rootViewMenu(self.parentViewController!, disablePanning: true)
        
        if self.useBlueColor {
            self.topBackgroundView.backgroundColor = UIColor.readyAppBlue()
            self.frontButton.setTitleColor(UIColor.readyAppBlue(), forState: UIControlState.Normal)
        }
        
        self.frontButton.userInteractionEnabled = false
        self.scrollView.delegate = self
        
        self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE
        self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE
        
        menuTapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("menuTapDetected:"))
        menuTapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(menuTapGestureRecognizer)
        menuTapGestureRecognizer.enabled = false
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        self.tapGestureRecognizer.numberOfTapsRequired = 1
        self.tapGestureRecognizer.numberOfTouchesRequired = 1
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handleDrag:"))
        self.panGestureRecognizer.maximumNumberOfTouches = 1
        
        currentPointer = UIImageView(image: UIImage(named: "pointer"))
        
        self.addPointerButton.hidden = true
        self.deleteButton.hidden = true
        self.spaceToDeleteConstraint.constant = self.view.frame.size.width //push the Delete button off the page
        
        self.setupVectorGraphics()
        
        // Setup the alert view that will be displayed if the user tries to select Next before selecting a body part
        let alertString = NSLocalizedString("Please select a body part before continuing", comment: "")
        var alertImageName = "x_red"
        if self.useBlueColor {
            alertImageName = "x_blue"
        }
        alertView = CustomAlertView.initWithText(alertString, imageName: alertImageName)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.delegate = self
        alertView.hidden = true
        self.view.addSubview(alertView)
        self.setupAlertViewConstraints()
        
        self.isMale = HealthKitManager.healthKitManager.isMale()
    }
    
    /**
    If this is the first time this view is being displayed, this function initializes the vector graphic image and displays it on the screen.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !(self.comingFromPainRating) {
            var imgName = "femalefront.svg"
            if self.isMale {
                imgName = "malefront.svg"
            }
            let vectorImage: SVGKImage = SVGKImage(named: imgName)
            vectorWidth = self.scrollView.frame.size.height / WIDTH_SCALE       // Ensure the vector graphic has the correct ratio
            vectorImage.size = CGSize(width: vectorWidth, height: self.scrollView.frame.size.height)
            self.setupConstraints()
            
            self.imgView.image = vectorImage
            
            // Disable pinch to zoom in the scroll view
            if scrollView.gestureRecognizers?.count > 0 {
                for i in 0...self.scrollView.gestureRecognizers!.count-1 {
                    let gesture: UIGestureRecognizer = self.scrollView.gestureRecognizers![i] 
                    if gesture.isKindOfClass(UIPinchGestureRecognizer) {
                        gesture.enabled = false
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Method to open the side panel
    */
    func openSideMenu() {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.scrollView.userInteractionEnabled = false
        menuTapGestureRecognizer.enabled = true
    }

    // MARK: Setup functions
    
    /**
    Setups of the SVGKit Layered Image View size and add the tap gesture recognizer
    */
    func setupVectorGraphics() {
        self.imgView = SVGKLayeredImageView(frame: CGRect(x: 0, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height))
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.userInteractionEnabled = true
        self.imgView.contentMode = UIViewContentMode.Center
        self.imgView.addGestureRecognizer(self.tapGestureRecognizer)
        self.scrollView.addSubview(imgView)
    }
    
    /**
    Adds constraints to the SVGKit Layered Image View so that it will fill the entire scroll view
    */
    func setupConstraints() {
        self.imgView.removeConstraints(self.imgView.constraints)
        var viewsDict = Dictionary<String, UIView>()
        let metricsDict = ["imgViewWidth": vectorWidth]
        viewsDict["imgView"] = self.imgView
        viewsDict["scrollView"] = self.scrollView
        
        // Height
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imgView]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[imgView(==scrollView)]", options: [], metrics: nil, views: viewsDict))
        
        // Width
        self.scrollView.addConstraint(NSLayoutConstraint(
            item: self.imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
         self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[imgView(imgViewWidth)]", options: [], metrics: metricsDict, views: viewsDict))
    }
    
    /**
    Setups the the custom alert view to fill the entire view
    */
    func setupAlertViewConstraints() {
        var viewsDict = Dictionary<String, UIView>()

        viewsDict["alertView"] = self.alertView
        viewsDict["view"] = self.view
      
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[alertView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: viewsDict))
    }
    
    // MARK: Gesture Recognizers
    
    /**
    Method to handle taps when the side menu is open
    
    - parameter recognizer: tap gesture used to call method
    */
    func menuTapDetected(recognizer: UITapGestureRecognizer) {
        let container = self.navigationController?.parentViewController as! ContainerViewController
        container.toggleLeftPanel()
        self.scrollView.userInteractionEnabled = true
        menuTapGestureRecognizer.enabled = false
    }
    
    /**
    If the scroll view is not zoomed in on a body part, this function will zoom in and color the tapped body part.  
    If already zoomed in, this function passes the tap gesture to the handlePointerTap() function
    
    - parameter recognizer: UITapGestureRecognizer that triggered this function
    */
    func handleTap(recognizer: UITapGestureRecognizer) {
        // If already zoomed in, call function to handle tap
        if self.zoomedIn {
            self.handlePointerTap(recognizer)
            return
        }
        
        var zoomIn: Bool = false    // will be set to true only if there are layers that are colored
        let point = recognizer.locationInView(self.imgView)
        let hitLayer: CALayer = self.imgView.layer.hitTest(point)!
        
        // Fill in the tapped layer
        originalFillColors = []
        lastTappedLayer = hitLayer
        let parentLayer = lastTappedLayer?.superlayer
        for layer in parentLayer!.sublayers! {
            if let childLayer = layer as? CAShapeLayer {
                zoomIn = true
                originalFillColors.append(childLayer.fillColor!)
                if self.useBlueColor {
                    childLayer.fillColor = UIColor.readyAppBlue().CGColor
                } else {
                    childLayer.fillColor = UIColor.readyAppRed().CGColor
                }
                childLayer.opacity = 0.8
            }
        }
        
        // Zoom into tapped layer
        if (zoomIn) {
            // Get the layer that contains the overall image. Need this to center on the tapped layer correctly. This is hacky and
            // depends on the SVG file being the correct format, but I dont see a way around this
            let imgLayer = lastTappedLayer!.superlayer!.superlayer
            
            // Get the center of the parent layer of the tapped layer. This parent layer is a square around that entire body part.
            var centerOfLayer = CGPointMake(CGRectGetMidX(lastTappedLayer!.superlayer!.frame), CGRectGetMidY(lastTappedLayer!.superlayer!.frame))
            centerOfLayer.x += imgLayer!.frame.origin.x
            centerOfLayer.y += imgLayer!.frame.origin.y
            
            var newZoom: CGFloat = MAX_ZOOM_SCALE
            newZoom = min(newZoom, self.scrollView.maximumZoomScale)
            
            let scrollViewSize = self.scrollView.bounds.size
            let width = scrollViewSize.width / newZoom
            let height = scrollViewSize.height / newZoom
            let x = centerOfLayer.x - (width / 2.0)
            let y = centerOfLayer.y - (height / 2.0)
            
            let rectToZoomInto = CGRect(x: x, y: y, width: width, height: height)
            self.zoomedIn = true
            self.scrollView.zoomToRect(rectToZoomInto, animated:true)
            
            // Remove and add appropriate gesture recognizers
            self.imgView.removeGestureRecognizer(self.tapGestureRecognizer)
            self.scrollView.addGestureRecognizer(self.tapGestureRecognizer)
            self.imgView.addGestureRecognizer(self.panGestureRecognizer)
        
        }
    }
    
    /**
    This function gets called when a tap is recognized when the view is zoomed in on a body part. The function determines
    if the tap was on one of the non-selected pain pointers and changes that pointer to the active one.
    
    - parameter recognizer: UITapGestureRecognizer that triggered this function
    */
    func handlePointerTap(recognizer: UITapGestureRecognizer) {
        let point = recognizer.locationInView(self.scrollView)
        for (index, element) in painPointers.enumerate() {
            let pointer = element as UIImageView
            /* 
            Found the first pointer in the stack that contains the point, so change the current pointer to light-gray,
            change the found pointer to dark gray, move the current pointer to the front and move it into index=0 (top of the stack)
            */
            if pointer.frame.contains(point) {
                currentPointer.image = UIImage(named: "pointerlight")
                pointer.image = UIImage(named: "pointer")
                currentPointer = pointer
                self.scrollView.bringSubviewToFront(currentPointer)
                self.painPointers.removeAtIndex(index)
                self.painPointers.insert(currentPointer, atIndex: 0)
                break
            }
        }
    }
    
    /**
    Only triggered when zoomed in on a body part. This function calculates the offset from the current posistion to the last position and then
    attempts to move the active pain pointer that same offset value.  Checks are done on the pain pointer's possible new location to make sure
    it doesn't fall outside of the active body part layer.
    
    - parameter recognizer: UIPanGestureRecognizer that trigged this function
    */
    func handleDrag(recognizer: UIPanGestureRecognizer){
        let point = recognizer.locationInView(self.imgView)
        var newX = false
        var newY = false
        var newOrigin: CGPoint = CGPoint(x: 0, y: 0)
        
        // If panning is over, reset the previousTouchLocation
        if recognizer.state == UIGestureRecognizerState.Ended {
            previousTouchLocation = CGPoint(x: 0, y: 0)
            return
        }
        
        // If first point of a new pan gesture, udpate previous so we can start grabbing offsets
        if previousTouchLocation.x == 0 && previousTouchLocation.y == 0 {
            previousTouchLocation = point
            return
        }
        
        let xOffset = (point.x - previousTouchLocation.x) * MAX_ZOOM_SCALE
        let yOffset = (point.y - previousTouchLocation.y) * MAX_ZOOM_SCALE
        
        previousTouchLocation = point
        
        // Test the x-coordinate change (the test point is the point of the arrow which is at half the width and the height)
        var testFrame = currentPointer.frame
        testFrame.offset(dx: xOffset, dy: 0)
        var testPoint = CGPoint(x: testFrame.origin.x + (currentPointer.frame.size.width / 2), y: testFrame.origin.y + testFrame.size.height)
        var hitLayer: CALayer = self.imgView.layer.hitTest(testPoint)!
        if hitLayer.superlayer == lastTappedLayer?.superlayer {
            newOrigin.x = testFrame.origin.x
        } else {
            newOrigin.x = currentPointer.frame.origin.x
        }
        
        // Test the y-coordinate change
        testFrame = currentPointer.frame
        testFrame.offset(dx: 0, dy: yOffset)
        testPoint = CGPoint(x: testFrame.origin.x + (currentPointer.frame.size.width / 2), y: testFrame.origin.y + testFrame.size.height)
        hitLayer = self.imgView.layer.hitTest(testPoint)!
        if hitLayer.superlayer == lastTappedLayer?.superlayer {
            newOrigin.y = testFrame.origin.y
        } else {
            newOrigin.y = currentPointer.frame.origin.y
        }
        
        // Move the pointer
        currentPointer.frame.origin = newOrigin
    }
    
    // MARK: Scroll View Methods
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    // Disable user interaction because app crashes if user taps on imageview while the scroll view is zooming
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        self.scrollView.userInteractionEnabled = false
    }
    
    /**
    When the scroll view has zoomed in on a body part, place a pain pointer at the center-ish of the layer.

    */
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        self.scrollView.userInteractionEnabled = true
        if self.zoomedIn {
            // Create pointer and place on screen
            var imgLayer = lastTappedLayer!.superlayer!.superlayer
            var centerOfLayer = CGPointMake(CGRectGetMidX(lastTappedLayer!.superlayer!.frame), CGRectGetMidY(lastTappedLayer!.superlayer!.frame))
            centerOfLayer.x += imgLayer!.frame.origin.x
            centerOfLayer.y += imgLayer!.frame.origin.y
            centerOfLayer.x = centerOfLayer.x * MAX_ZOOM_SCALE - PAIN_POINTER_WIDTH / 2
            centerOfLayer.y = centerOfLayer.y * MAX_ZOOM_SCALE - PAIN_POINTER_HEIGHT

            currentPointer.frame = CGRectMake(centerOfLayer.x, centerOfLayer.y, PAIN_POINTER_WIDTH, PAIN_POINTER_HEIGHT)
            self.scrollView.addSubview(currentPointer)
            self.painPointers.insert(currentPointer, atIndex: 0)
            
            self.frontButton.hidden = true
            self.backButton.hidden = true
            self.addPointerButton.hidden = false
            
            self.navBar.leftBarButtonItem?.image = UIImage(named: "back_button")
            self.navBar.leftBarButtonItem?.action = Selector("navBackButtonClicked:")
        } else {
            if self.navigationController?.viewControllers.count == 1 {
                self.navBar.leftBarButtonItem?.image = UIImage(named: "menu_icon")
                self.navBar.leftBarButtonItem?.action = Selector("openSideMenu")
            }
        }
    }
    // MARK: Custom Alert View Delegate method
    
    /**
    Custom alert view delegate method that is triggered when the alert view is tapped.
    */
    func handleAlertTap() {
        self.alertView.hidden = true
    }
    
    // MARK: - IBActions
    
    /**
    Shows the front view of the vector graphic, the FRONT button is disabled once this is pressed.
    */
    @IBAction func frontClicked(sender: AnyObject) {
        self.frontButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14.0)
        if self.useBlueColor {
            self.frontButton.setTitleColor(UIColor.readyAppBlue(), forState: UIControlState.Normal)
        } else {
            self.frontButton.setTitleColor(UIColor.readyAppRed(), forState: UIControlState.Normal)
        }
        self.backButton.titleLabel?.font = UIFont(name: "Roboto-Light", size: 14.0)
        self.backButton.setTitleColor(UIColor.readyAppBlack(), forState: UIControlState.Normal)
        self.frontButton.userInteractionEnabled = false
        self.backButton.userInteractionEnabled = true
        
        var imgName = "femalefront.svg"
        if self.isMale {
            imgName = "malefront.svg"
        }
        let test: SVGKImage = SVGKImage(named: imgName)
        test.size = CGSize(width: vectorWidth, height: self.scrollView.frame.size.height)
        imgView.image = test
    }
    
    /**
    Shows the back view of the vector graphic, the BACK button is disabled once this is pressed
    */
    @IBAction func backClicked(sender: AnyObject) {
        self.backButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14.0)
        if self.useBlueColor {
            self.backButton.setTitleColor(UIColor.readyAppBlue(), forState: UIControlState.Normal)
        } else {
            self.backButton.setTitleColor(UIColor.readyAppRed(), forState: UIControlState.Normal)
        }
        self.frontButton.titleLabel?.font = UIFont(name: "Roboto-Light", size: 14.0)
        self.frontButton.setTitleColor(UIColor.readyAppBlack(), forState: UIControlState.Normal)
        self.backButton.userInteractionEnabled = false
        self.frontButton.userInteractionEnabled = true

        var imgName = "femaleback.svg"
        if self.isMale {
            imgName = "maleback.svg"
        }
        let test: SVGKImage = SVGKImage(named: imgName)
        test.size = CGSize(width: vectorWidth, height: self.scrollView.frame.size.height)
        imgView.image = test
    }

    /**
    Adds another pain pointer to the screen. If this is the first pain pointer added, the DELETE button will be moved onscreen. If this is 
    the 5th pain pointer added, then the ADD POINTER button is slid off the screen.

    */
    @IBAction func addPainPointerClicked(sender: AnyObject) {
        if (self.deleteButton.hidden == true) {
            self.deleteButton.hidden = false
            self.leadingSpaceAddPointerConstraint.constant = self.addPointerButton.frame.origin.x - self.addPointerButton.frame.size.width/2 - 3
            self.spaceToDeleteConstraint.constant = 6
            self.view.removeConstraint(centerAddPointerConstraint)
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        // Turn current pointer to gray and add a new pain pointer
        currentPointer.image = UIImage(named: "pointerlight")
        var newFrame = CGRect(x: currentPointer.frame.origin.x + 10, y: currentPointer.frame.origin.y + 10, width: PAIN_POINTER_WIDTH, height: PAIN_POINTER_HEIGHT)
        let testPoint = CGPoint(x: newFrame.origin.x + (newFrame.size.width/2), y: newFrame.origin.y + newFrame.size.height)
        let hitLayer: CALayer = self.imgView.layer.hitTest(testPoint)!
        // If this location is not in the body part layer, place the pointer to the upper left of the current pointer
        if !(hitLayer.superlayer == lastTappedLayer?.superlayer) {
            newFrame.origin.x -= 2 * 10
            newFrame.origin.y -= 2 * 10
        }
        
        currentPointer = UIImageView(frame: newFrame)
        currentPointer.image = UIImage(named: "pointer")
        painPointers.insert(currentPointer, atIndex: 0)
        self.scrollView.addSubview(currentPointer)
        
        // If we are at the max number of pain pointers, slide the addPointer button off the screen
        if painPointers.count == MAX_NUM_POINTERS {
            self.saveLeadingConstaintValue = self.leadingSpaceAddPointerConstraint.constant
            self.leadingSpaceAddPointerConstraint.constant = 0 - self.addPointerButton.frame.size.width
            self.spaceToDeleteConstraint.constant = (self.view.frame.size.width / 2) - (self.deleteButton.frame.size.width / 2)
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    /**
    Removes the currently selected pain pointer. If there are 5 pain pointers, when this is clicked the ADD POINTER button will slide back 
    onto the screen. If there are 2 pain pointers and 1 is deleted, the DELETE button is slid off the screen.
    
    */
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        currentPointer.removeFromSuperview()
        painPointers.removeAtIndex(0)
        currentPointer = painPointers[0]
        currentPointer.image = UIImage(named: "pointer")
        
        if painPointers.count == 1 {
            self.leadingSpaceAddPointerConstraint.constant = self.addPointerButton.frame.origin.x + self.addPointerButton.frame.size.width/2 + 3
            self.spaceToDeleteConstraint.constant = self.view.frame.size.width - self.deleteButton.frame.origin.x
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.deleteButton.hidden = true
                }
            })
        } else if painPointers.count == MAX_NUM_POINTERS - 1 {
            self.leadingSpaceAddPointerConstraint.constant = self.saveLeadingConstaintValue
            self.spaceToDeleteConstraint.constant = 6
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    /**
    If a body part has not been selected, show an alert. Otherwise segue to the PainRatingViewController.
    
    */
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if self.zoomedIn {
            self.comingFromPainRating = true
            self.performSegueWithIdentifier("painRatingSegue", sender: self)
        } else {
            self.alertView.hidden = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "painRatingSegue" {
            let vc: PainRatingViewController = segue.destinationViewController as! PainRatingViewController
            vc.useBlueColor = self.useBlueColor
        }
    }
    
    /**
    If the back button is clicked when zoomed in on a body part, the view will clear all the pain pointers and zoom back out to 
    showing the entire body. If the back button is clicked when zoomed out, then we will pop to the previous view controller.
    
    */
    @IBAction func navBackButtonClicked(sender: AnyObject) {
        if (self.zoomedIn) {
            // Clear the last tapped layer
            if let lastLayer = lastTappedLayer {
                let parentLayer = lastLayer.superlayer
                for var index = 0; index < parentLayer!.sublayers!.count; ++index {
                    if let childLayer = parentLayer!.sublayers![index] as? CAShapeLayer {
                        childLayer.fillColor = originalFillColors[index]
                        childLayer.opacity = 1.0
                    }
                }
            }
            
            // Move Delete button offscreen, shift addPointer button back to center
            if self.painPointers.count == MAX_NUM_POINTERS {
                self.leadingSpaceAddPointerConstraint.constant = self.saveLeadingConstaintValue
                self.leadingSpaceAddPointerConstraint.constant += self.addPointerButton.frame.size.width/2 + 3
                self.spaceToDeleteConstraint.constant = self.view.frame.size.width - self.deleteButton.frame.origin.x
            } else if self.painPointers.count > 1 && self.painPointers.count < MAX_NUM_POINTERS {
                self.leadingSpaceAddPointerConstraint.constant = self.addPointerButton.frame.origin.x + self.addPointerButton.frame.size.width/2 + 3
                self.spaceToDeleteConstraint.constant = self.view.frame.size.width - self.deleteButton.frame.origin.x
            }
            self.view.layoutIfNeeded()
            
            // Remove pain pointers
            for pointer in self.painPointers {
                pointer.removeFromSuperview()
            }
            self.painPointers.removeAll(keepCapacity: true)
            
            // Zoom out
            var rectToZoomInto = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            self.scrollView.zoomToRect(rectToZoomInto, animated:true)
            
            // Show/hide appropriate buttons
            self.frontButton.hidden = false
            self.backButton.hidden = false
            self.addPointerButton.hidden = true
            self.deleteButton.hidden = true
            self.zoomedIn = false
            
            // Change gesture recognizers
            self.scrollView.removeGestureRecognizer(self.tapGestureRecognizer)
            self.imgView.addGestureRecognizer(self.tapGestureRecognizer)
            self.imgView.removeGestureRecognizer(self.panGestureRecognizer)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
