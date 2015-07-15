/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014, 2015. All Rights Reserved.
*/

import UIKit

/**
Simple custom cell to display a label and a custom disclosureimage
*/
class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var disclosureImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
