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
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet var memeTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
        if(memes.count == 0){
            println("going to edit view");
            if let hostView = self.view {
                dispatch_async(dispatch_get_main_queue()) {
                    self.goToEditView()
                }
            } else {
                // handle nil hostView 
            }
            // goToEditView()
        }
        //delete.hidden = true
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
            showDetailView(indexPath.row)
        }
        else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
            cell.checkMark.hidden = false
            cell.isSelected = true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as AppDelegate
            memes.removeAtIndex(indexPath.row)
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
        cell.checkMark.hidden = true
        cell.isSelected = false
    }
    
    @IBAction func rightNavBarButtonAction(sender: UIBarButtonItem) {
        if(!isEditing){
            isEditing = true
            memeTableView.allowsMultipleSelection = true
            setTabBarVisible(false, animated: true)
            leftBarButton.title = "Delete"
            rightBarButton.title = "Cancel"
        }
        else {
            rightBarButton.title = "Edit"
            leftBarButton.title = "Back"
            setTabBarVisible(true, animated: true)
            isEditing = false
        }
    }
    
    func showDetailView(index: Int){
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        detailController.meme = memes[index]
        detailController.index = index
        detailController.tabBar = self.tabBarController?.tabBar as CustomTabBar
        self.navigationController?.pushViewController(detailController, animated: true)
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
    }
    
    func deleteMemes(){
        
        if let indexPaths = tableView.indexPathsForSelectedRows() {
            for(var i = indexPaths.count - 1; i >= 0; i--){
                var indexPath = indexPaths[i] as NSIndexPath
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as AppDelegate
                appDelegate.memes.removeAtIndex(indexPath.row)
                memes.removeAtIndex(indexPath.row)
                memeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    @IBAction func leftNavBarButtonAction(sender: UIBarButtonItem) {
        if(isEditing){
            deleteMemes()
            isEditing = false
            leftBarButton.title = "Back"
        }
        else {
            goToEditView()
            // self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func goToEditView(){
        let editVC = storyboard?.instantiateViewControllerWithIdentifier("EditView") as ViewController
        // presentViewController(editVC, animated: true, completion: nil)
        // self.navigationController?.popToRootViewControllerAnimated(false)
        // http://stackoverflow.com/questions/19890761/warning-presenting-view-controllers-on-detached-view-controllers-is-discourage
        // http://stackoverflow.com/questions/8563473/unbalanced-calls-to-begin-end-appearance-transitions-for-uitabbarcontroller        
        
        dispatch_async(dispatch_get_main_queue()) {
            // self.navigationController?.tabBarController?.presentViewController(editVC, animated: false, completion: nil)
            self.presentViewController(editVC, animated: false, completion: nil)
        }
        
        // self.tabBarController?.presentViewController(editVC, animated: false, completion: nil)
        // self.dismissViewControllerAnimated(true, completion: nil)
        // performSegueWithIdentifier("editView", sender: self)
        // self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    func deleteMeme(indexPath: NSIndexPath){
        memes.removeAtIndex(indexPath.row)
        memeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}