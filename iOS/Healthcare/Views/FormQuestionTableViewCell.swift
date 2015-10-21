/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/


import UIKit

/**
*  Custom table view cell to present a question for the user to answer. When tapped, the image view toggles
*  between a checkmark and an empty circle.  Used in FormsViewController and EndRoutineViewController
*/
class FormQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    var isSelected2 = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }

    func selectedCell() {
        isSelected2 = !isSelected2
        if isSelected2 {
            self.selectedImageView.image = UIImage(named: "checkmark_blue")
        } else {
            self.selectedImageView.image = UIImage(named: "form_unselected")
        }
    }

}
