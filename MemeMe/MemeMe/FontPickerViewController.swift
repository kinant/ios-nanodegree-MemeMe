//
//  FontPickerViewController.swift
//  ColorPickerExample
//
//  Created by Kinan Turjman on 3/26/15.
//  Copyright (c) 2015 Ethan Strider. All rights reserved.
//

import Foundation
import UIKit

class FontPickerViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: ViewController? = nil
    var font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
    
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    let fonts1 = [
        "Georgia Bold",
        "Arial Bold",
        "Cochin Bold",
        "American Typewriter Bold"
    ]
    
    let fonts = UIFont.familyNames()
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fonts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FontCell") as UITableViewCell
        // Set the name and image
        if let textValue = (self.fonts[indexPath.row] as? String) {
            cell.textLabel?.text = textValue
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let textValue = (self.fonts[indexPath.row] as? String) {
            font = UIFont(name: textValue, size: 40)
            delegate?.setTextFont(font!)
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}