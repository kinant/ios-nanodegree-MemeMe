//
//  Helper.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/9/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

var templates = [Template]()

var titles = [
    "One Does Not Simply",
    "Ancient Aliens",
    "The Most Interesting Man In The World",
    "X, X Everywhere",
    "Futurama Fry",
    "First World Problems",
    "Bad Luck Brian",
    "Y U No",
    "Leonardo Dicaprio Cheers",
    "Brace Yourselves X is Coming",
    "Grumpy Cat",
    "Success Kid",
    "That Would Be Great",
    "Captain Picard Facepalm",
    "Am I The Only One Around Here",
    "Philosoraptor",
    "Skeptical Baby",
    "Conspiracy Keanu",
    "Overly Attached Girlfriend",
    "Liam Neeson Taken"
]

var images = [String]()

struct Template {
    var image: UIImage
    var title: String
    
    init(image: UIImage, title: String){
        self.image = image
        self.title = title
    }
}

func fillTemplates(){
    for(var i = 0; i < titles.count; i++){
        println("processing: \(titles[i]) t\(i + 1).jpg")
        var image = UIImage(named: "t\(i + 1).jpg")
        var template = Template(image: image!, title: titles[i])
        templates.append(template)
    }
}