/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit
import QuartzCore

/**
Reusable CollectionView that acts as a horizontal scrolling number picker
*/
class MILRatingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    var dummyBackgroundView: UIView!
    var circularView: UIView!
    var selectedIndexPath: NSIndexPath?
    var ratingCellID = "ratingCell"
    var centerIsSet = false
    
    private var currentNumberRange: NSRange = NSMakeRange(0, 10)
    /// The range of the collectionView, location is the starting number, length is the number of elements
    var numberRange: NSRange {
        set(value) {
            currentNumberRange = value
            selectedIndexPath = NSIndexPath(forRow: (currentNumberRange.length - currentNumberRange.location)/2, inSection: 0)
        }
        get {
            return currentNumberRange
        }
    }
    
    /// Private delegate so callbacks in this class will be called before any child class
    private var actualDelegate: UICollectionViewDelegate?
    /// Private datasource so callbacks in this class will be called before any child class
    private var actualDataSource: UICollectionViewDataSource?
    
    /// custom delegate property accessible to external classes
    var preDelegate: UICollectionViewDelegate? {
        set(newValue) {
            self.actualDelegate = newValue
            //super.delegate = self
        }
        get {
            return self.actualDelegate
        }
    }
    
    /// custom datasource property accessible to external classes
    var preDataSource: UICollectionViewDataSource? {
        set(newValue) {
            self.actualDataSource = newValue
            //super.dataSource = self
        }
        get {
            return self.actualDataSource
        }
    }
    
    // Init method called programmaticly
    convenience init(frame: CGRect) {
        self.init(frame: frame)
        initView()
    }

    // Init method called from storyboard
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()

    }
    
    /**
    MILRatingCollectionView set up method, initializes background and collectionView properties.
    */
    func initView() {
        super.delegate = self
        super.dataSource = self
        
        self.collectionViewLayout = UICollectionViewFlowLayoutCenterItem(viewWidth: UIScreen.mainScreen().bounds.size.width)
        self.showsHorizontalScrollIndicator = false
        self.registerClass(RatingCollectionViewCell.self, forCellWithReuseIdentifier: ratingCellID)
        
        // create ciruclarview and fix in the middle of the collectionView background
        circularView = UIView(frame: CGRectMake(0, 0, 100, 100))
        circularView.backgroundColor = UIColor.readyAppRed()
        self.setRoundedViewToDiameter(circularView, diameter: circularView.frame.size.height)
        dummyBackgroundView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        dummyBackgroundView.addSubview(circularView)
        self.backgroundView = dummyBackgroundView
        
        setUpAutoLayoutConstraints()
    }
    
    // MARK: CollectionView delegate and datasource
    
    // number of items based on number range set by developer
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentNumberRange.length
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: RatingCollectionViewCell?
        // if preDataSource not set by developer, create cell like normal
        if let ds = preDataSource {
            cell = ds.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? RatingCollectionViewCell
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(ratingCellID, forIndexPath: indexPath) as? RatingCollectionViewCell
        }
        
        cell!.numberLabel.text = "\(indexPath.row + currentNumberRange.location)" // offset to start at 1
        
        // sets an initial highlighted cell, only true once
        if !centerIsSet && indexPath == selectedIndexPath {
            cell!.setAsHighlightedCell()
            centerIsSet = true
        }
        
        return cell!
    }
    
    /**
    Method to round corners enough to make a circle based on diameter.
    
    :param: view     UIView to circlefy
    :param: diameter the desired diameter of your view
    */
    func setRoundedViewToDiameter(view: UIView, diameter: CGFloat) {
        var saveCenter = view.center
        var newFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, diameter, diameter)
        view.frame = newFrame
        view.layer.cornerRadius = diameter / 2.0
        view.center = saveCenter
    }
    
    // MARK ScrollView delegate methods
    
    /**
    Method replicating the functionality of indexPathForItemAtPoint(), which was not working with the custom flow layout
    
    :param: point center point to find most centered cell
    
    :returns: UICollectionViewLayoutAttributes of the centered cell
    */
    func grabCellAttributesAtPoint(point: CGPoint) -> UICollectionViewLayoutAttributes? {
        
        var visible = self.indexPathsForVisibleItems()
        
        for paths in visible {
            var layoutAttributes = self.layoutAttributesForItemAtIndexPath(paths as! NSIndexPath)
            
            // true when center point is within a cell's frame
            if CGRectContainsPoint(layoutAttributes!.frame, point) {
                return layoutAttributes!
                
            }
        }
        return nil
    }
    
    /**
    Method that recognizes center cell and highlights it while leaving other cells normal
    
    :param: scrollView scrollView built into the UICollectionView
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Get centered point within collectionView contentSize, y value not crucial, just needs to always be in center
        var centerPoint = CGPointMake(self.center.x + self.contentOffset.x,
            self.contentSize.height / 2)
        
        if var attributes = grabCellAttributesAtPoint(centerPoint) {
            
            // true when center cell has changed, revert old center cell to normal cell
            if selectedIndexPath != attributes.indexPath {
                if let oldPath = selectedIndexPath {
                    if var previousCenterCell = self.cellForItemAtIndexPath(oldPath) as? RatingCollectionViewCell {
                        previousCenterCell.setAsNormalCell()
                    }
                }
                
                // make current center cell a highlighted cell
                var cell = self.cellForItemAtIndexPath(attributes.indexPath) as! RatingCollectionViewCell
                cell.setAsHighlightedCell()
                selectedIndexPath = attributes.indexPath
                
            } 
        }
    }
    
    /**
    Autolayout constraints for the circular background view
    */
    func setUpAutoLayoutConstraints() {
        self.circularView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.dummyBackgroundView.addConstraint(NSLayoutConstraint(
            item:self.circularView, attribute:.CenterX,
            relatedBy:.Equal, toItem:self.dummyBackgroundView,
            attribute:.CenterX, multiplier:1, constant:0))
        self.dummyBackgroundView.addConstraint(NSLayoutConstraint(
            item:self.circularView, attribute:.CenterY,
            relatedBy:.Equal, toItem:self.dummyBackgroundView,
            attribute:.CenterY, multiplier:1, constant:0))
        self.dummyBackgroundView.addConstraint(NSLayoutConstraint(
            item:self.circularView, attribute:.Height,
            relatedBy:.Equal, toItem:nil,
            attribute:.NotAnAttribute, multiplier:1, constant:100))
        self.dummyBackgroundView.addConstraint(NSLayoutConstraint(
            item:self.circularView, attribute:.Width,
            relatedBy:.Equal, toItem:nil,
            attribute:.NotAnAttribute, multiplier:1, constant:100))
    }

}
