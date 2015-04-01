//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme:Meme!
    
    override func viewDidLoad() {
        self.imageView.image = meme.memeImg;
    }
}