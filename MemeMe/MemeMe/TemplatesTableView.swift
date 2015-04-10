//
//  TemplatesTableView.swift
//  MemeMe
//
//  Created by Kinan Turjman on 4/9/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

class TemplatesTableViewController: UITableViewController, UITableViewDataSource {
    
    var delegate: ViewController? = nil
    var isEditing = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as CustomTableViewCell
        let template = templates[indexPath.row]
        
        // Set the name and image
        cell.topText.text = template.title
        cell.memeImage.image = template.image
        cell.bottomText.text = ""
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editVC = storyboard!.instantiateViewControllerWithIdentifier("editView") as ViewController
        self.presentViewController(editVC, animated: true, completion: {
            editVC.imageView.image = templates[indexPath.row].image
            editVC.setScrollView()
        })
    }
    
}
