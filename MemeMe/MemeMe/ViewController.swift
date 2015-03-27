//
//  ViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/26/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorPick: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // colorPick.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}