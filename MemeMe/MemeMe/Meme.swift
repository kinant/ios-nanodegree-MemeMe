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
    var font: UIFont
    var fontColor: UIColor
    var originalImgOriginX : CGFloat
    var originalImgOriginY : CGFloat
    var zoomScale: CGFloat
    
    init(topText: String, bottomText: String, original: UIImage,originalX: CGFloat, originalY: CGFloat, zoom: CGFloat, meme: UIImage, font: UIFont, fontColor: UIColor){
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