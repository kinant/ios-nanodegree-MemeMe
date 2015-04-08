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
    var isEditing = false
    // MARK: Table View Data Source
    
    @IBOutlet var memeTableView: UITableView!
    
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
    
        if(!isEditing){
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
            detailController.meme = self.memes[indexPath.row]
            presentViewController(detailController, animated: true, completion: nil)
        }
        else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
            cell.checkMark.hidden = false
        }
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
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
        cell.checkMark.hidden = true
    }
    
    @IBAction func editMemeTableView(sender: UIBarButtonItem) {
        isEditing = true
        memeTableView.allowsMultipleSelection = true
        setTabBarVisible(false, animated: false)
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }}