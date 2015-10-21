/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
CollectionViewCell consisting of a number label that varies in size if it is the most centered cell
*/
class RatingCollectionViewCell: UICollectionViewCell {
    
    var numberLabel: UILabel!
    
    /**
    Init method to initialize the UICollectionViewCell with a number label
    
    - parameter frame: size of the cell
    
    - returns: UICollectionViewCell object
    */
    override init(frame: CGRect) {
        super.init(frame: frame)

        numberLabel = UILabel()
        numberLabel.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        numberLabel.font = UIFont(name: "RobotoSlab-Regular", size: 30)
        self.contentView.addSubview(numberLabel)
        
        setUpAutoLayoutConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Method to increase number size and animate with a popping effect
    */
    func setAsHighlightedCell() {
        self.numberLabel.textColor = UIColor.whiteColor()
        self.numberLabel.font = UIFont(name: "RobotoSlab-Bold", size: 65)
        self.numberLabel.transform = CGAffineTransformScale(self.numberLabel.transform, 0.5, 0.5)
        UIView.animateWithDuration(0.3, animations: {
            self.numberLabel.transform = CGAffineTransformMakeScale(1.0,1.0)
            
        })
    }
    
    /**
    Returns cells back to their original state and smaller size.
    */
    func setAsNormalCell() {
        self.numberLabel.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        self.numberLabel.font = UIFont(name: "RobotoSlab-Regular", size: 30)
        self.numberLabel.transform = CGAffineTransformScale(self.numberLabel.transform, 2.0, 2.0)
        UIView.animateWithDuration(0.1, animations: {
            self.numberLabel.transform = CGAffineTransformMakeScale(1.0,1.0)
            
        })
    }
    
    func setUpAutoLayoutConstraints() {
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(
            item:self.numberLabel, attribute:.CenterX,
            relatedBy:.Equal, toItem:self,
            attribute:.CenterX, multiplier:1, constant:0))
        self.addConstraint(NSLayoutConstraint(
            item:self.numberLabel, attribute:.CenterY,
            relatedBy:.Equal, toItem:self,
            attribute:.CenterY, multiplier:1, constant:0))
    }
}
