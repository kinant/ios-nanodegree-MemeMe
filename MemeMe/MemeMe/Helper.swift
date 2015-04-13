//
//  Helper.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/9/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

/* Helper swift file for the declaration of the templates Template array
 * and the functions used to fill it up
*/

var templates = [Template]() // the array of template objects

// an array of all the template titles
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
 // array that will contain the paths to all the images
var images = [String]()

// definie the Template Struct
struct Template {
    var image: UIImage // image of the template
    var title: String // template's title
    
    init(image: UIImage, title: String){
        self.image = image
        self.title = title
    }
}

// function to fill the templates array
// this is much quicker than doing each template by itself
func fillTemplates(){
    // iterates over each title, creates a new template and appends it to the array
    for(var i = 0; i < titles.count; i++){
        
        // set the image
        var image = UIImage(named: "t\(i + 1).jpg")
        
        // create the template
        var template = Template(image: image!, title: titles[i])
        
        // append
        templates.append(template)
    }
}