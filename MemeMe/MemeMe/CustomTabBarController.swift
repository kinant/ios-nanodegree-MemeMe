//
//  CustomTabBarController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/13/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    override func viewWillAppear(animated: Bool) {
        println("tab barrrrrrrrr controllerrrrr")
        let editVC = storyboard?.instantiateViewControllerWithIdentifier("EditView") as ViewController
        // presentViewController(editVC, animated: true, completion: nil)
        // self.navigationController?.popToRootViewControllerAnimated(false)
        // http://stackoverflow.com/questions/19890761/warning-presenting-view-controllers-on-detached-view-controllers-is-discourage
        self.navigationController?.tabBarController?.presentViewController(editVC, animated: false, completion: nil)
    }
}