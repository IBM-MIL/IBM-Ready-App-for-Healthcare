/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Custom collectionViewFlowLayout in order to have paging on the centered cell
*/
class UICollectionViewFlowLayoutCenterItem: UICollectionViewFlowLayout {
    
    /**
    Init method that sets default properties for collectionViewlayout
    
    :param: viewWidth width of screen to base paddings off of.
    
    :returns: UICollectionViewFlowLayout object
    */
    init(viewWidth: CGFloat) {
        super.init()

        var cellSize: CGSize = CGSizeMake(65, 100)
        var inset = viewWidth/2 - cellSize.width/2
        
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.itemSize = CGSizeMake(cellSize.width, cellSize.height)
        self.minimumInteritemSpacing = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Obj-C version taken from: https://gist.github.com/mmick66/9812223
    // Method ensures a cell is centered when scrolling has ended
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var width = self.collectionView!.bounds.size.width
        var proposedContentOffsetCenterX = proposedContentOffset.x + width * CGFloat(0.5)
        var proposedRect = self.layoutAttributesForElementsInRect(self.collectionView!.bounds) as! [UICollectionViewLayoutAttributes]
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        for attributes in proposedRect {
            
            // this ignores header and footer views
            if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                continue
            }
            
            // set initial value first time through loop
            if (candidateAttributes == nil) {
                candidateAttributes = attributes
                continue
            }
            
            // if placement is desired, update candidateAttributes
            if (fabsf(Float(attributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(candidateAttributes!.center.x) - Float(proposedContentOffsetCenterX))) {
                candidateAttributes = attributes
            }
            
        }

        return CGPointMake(candidateAttributes!.center.x - width * CGFloat(0.5), proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        var oldBounds = self.collectionView!.bounds
        if CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds) {
            return true
        }
        return false
    }
   
}
