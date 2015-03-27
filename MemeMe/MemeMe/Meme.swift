//
//  Meme.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/27/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText:String
    var bottomText:String
    var originalImg:UIImage
    var memeImg:UIImage
    
    init(topText: String, bottomText: String, original: UIImage, meme: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImg = original
        self.memeImg = meme
    }
}