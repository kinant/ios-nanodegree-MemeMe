//
//  TableViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDataSource {
    
    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    var memes: [Meme]!
    var delegate: ViewController? = nil
    
    // MARK: Table View Data Source
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as CustomTableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memeImage.image = meme.memeImg
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}