//
//  Meme.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/27/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

// create the Meme struct and all its properties
struct Meme {
    var topText:String // for the top text
    var bottomText:String // for the bottom text
    var originalImg:UIImage // for the original image
    var memeImg:UIImage // for the memed image
    var font: UIFont // for the text font (for editing)
    var fontColor: UIColor // for the text color (for editing)
    var originalImgOriginX : CGFloat // the original origin x coordinate (for editing)
    var originalImgOriginY : CGFloat // the original origin y coordinate (for editing)
    var zoomScale: CGFloat // the zoom scale that was applied (for editing)
    
    // initializer function
    init(topText: String, bottomText: String, original: UIImage,originalX: CGFloat, originalY: CGFloat, zoom: CGFloat, meme: UIImage, font: UIFont, fontColor: UIColor){
        
        // set all the properties
        self.topText = topText
        self.bottomText = bottomText
        self.originalImg = original
        self.originalImgOriginX = originalX
        self.originalImgOriginY = originalY
        self.zoomScale = zoom
        self.memeImg = meme
        self.fontColor = fontColor
        self.font = font
    }
}