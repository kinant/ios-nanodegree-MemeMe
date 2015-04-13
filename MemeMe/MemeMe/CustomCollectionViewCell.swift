//
//  CustomCollectionViewCell.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

/* This class is used for Custom Collection View Cells
*/
class CustomCollectionViewCell : UICollectionViewCell {
    
    // Outlets
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // customize the way the image is displayed
        // in this case we are making a rounded image
        // Code from: http://stackoverflow.com/questions/25587713/how-to-set-imageview-in-circle-like-imagecontacts-in-swift-correctly
        memeImage.layer.borderWidth=1.0
        memeImage.layer.masksToBounds = false
        memeImage.layer.borderColor = UIColor.whiteColor().CGColor
        memeImage.layer.cornerRadius = 10
        memeImage.clipsToBounds = true
    }
}