//
//  CustomTableViewCell.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell {

    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    @IBOutlet var memeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // memeImage = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        
        memeImage.layer.borderWidth=1.0
        memeImage.layer.masksToBounds = false
        memeImage.layer.borderColor = UIColor.whiteColor().CGColor
        memeImage.layer.cornerRadius = 10
        // memeImage.layer.cornerRadius = memeImage.frame.size.height/2
        memeImage.clipsToBounds = true
    }
}