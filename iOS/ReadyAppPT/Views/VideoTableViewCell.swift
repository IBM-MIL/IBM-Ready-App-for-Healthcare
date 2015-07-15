/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Custom tableViewCell to display a video thumbnail and other details about an exercise video.
*/
class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    var videoStats = (0,0,0)
    var tools = ""
    var videoID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbNail.layer.cornerRadius = 10.0
        self.thumbNail.layer.borderWidth = 1.0
        self.thumbNail.layer.borderColor = UIColor(red: 29/255.0, green: 178/255.0, blue: 236/255.0, alpha: 1.0).CGColor
        self.thumbNail.clipsToBounds = true
        self.exerciseTitle.adjustsFontSizeToFitWidth = true
        self.exerciseDescription.adjustsFontSizeToFitWidth = true
        self.minuteLabel.adjustsFontSizeToFitWidth = true
        self.repsLabel.adjustsFontSizeToFitWidth = true
        self.setsLabel.adjustsFontSizeToFitWidth = true
    }
    
    /**
    Method to format text, part bold and part light. Specifically for labels on the VideoTableViewCell
    
    :param: min  the number of minutes for an exercise
    :param: rep  the number of reps for an exercise
    :param: sets the number of sets for an exercise
    */
    func setExerciseStats(min: Int, rep: Int, sets: Int) {
        
        var lightFont = UIFont(name: "RobotoSlab-Light", size: 13)!
        var boldFont = UIFont(name: "RobotoSlab-Bold", size: 13)!

        var attr = [NSFontAttributeName:lightFont]
        var subAttr = [NSFontAttributeName:boldFont]
        
        var minText = NSLocalizedString(" MIN", comment: "n/a")
        var repText = NSLocalizedString(" REP", comment: "n/a")
        var setsText = NSLocalizedString(" SET", comment: "n/a")
        
        var stringMin = Utils.formatSingleDigits(min)
        var stringRep = Utils.formatSingleDigits(rep)
        var stringSets = Utils.formatSingleDigits(sets)
        
        var theRange = NSMakeRange(0, count(stringMin))
        var attributedString = NSMutableAttributedString(string: stringMin + minText, attributes: attr)
        attributedString.setAttributes(subAttr, range: theRange)
        minuteLabel.attributedText = attributedString
        
        theRange = NSMakeRange(0, count(stringRep))
        var repAttributedString = NSMutableAttributedString(string: stringRep + repText, attributes: attr)
        repAttributedString.setAttributes(subAttr, range: theRange)
        repsLabel.attributedText = repAttributedString
        
        theRange = NSMakeRange(0, count(stringSets))
        var setsAttributedString = NSMutableAttributedString(string: stringSets + setsText, attributes: attr)
        setsAttributedString.setAttributes(subAttr, range: theRange)
        setsLabel.attributedText = setsAttributedString
        
        self.videoStats = (min, rep, sets)
    }

}
