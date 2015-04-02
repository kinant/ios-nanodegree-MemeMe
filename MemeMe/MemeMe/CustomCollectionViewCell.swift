//
//  CustomCollectionViewCell.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        memeImage.layer.borderWidth=1.0
        memeImage.layer.masksToBounds = false
        memeImage.layer.borderColor = UIColor.whiteColor().CGColor
        memeImage.layer.cornerRadius = 10
        memeImage.clipsToBounds = true
    }
}