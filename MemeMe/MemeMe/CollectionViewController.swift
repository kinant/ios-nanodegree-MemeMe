//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation

import UIKit

/* This class is used for the Saved Memes Collection View
*/
class CollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem! // left nav bar button
    @IBOutlet weak var rightBarButton: UIBarButtonItem! // right nav bar button
    @IBOutlet var memeCollectionView: UICollectionView! // the collection view itself
    
    var memes:[Meme]! // array to hold all the saved memes
    var isEditing = false // flag for when editing memes (in this case just to delete one or more)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        memeCollectionView.backgroundColor = UIColor.orangeColor()
    }
    
    // MARK: Collection View Functions
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as CustomCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.memeImage.image = meme.memeImg
        
        return cell
    }
    
    // handle what happens when collection view memes are selected
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // check for flag, make sure not in editing mode (when deleting memes)
        if(!isEditing){
            
            // if not editing, show the meme detail view
            showDetailView(indexPath.row)
        }
        else {
            // if not, then we are editing, so we can select more than one cell.
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as CustomCollectionViewCell
            
            // unhide the cells checkmark
            cell.checkMark.hidden = false
        }
    }
    
    // When editing, we can deselect a meme, so that it will no longer be highlited
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CustomCollectionViewCell
        
        // hide the checkmark
        cell.checkMark.hidden = true
    }
    
    // function that handles the deletion of the selected memes (when editing)
    func deleteMemes(){
        
        // get all the index paths for the selected items (if any have been selected)
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            
            // create the link to the app elegate, so we have access to
            // the memes object array
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as AppDelegate
            
            // iterate over all index paths
            for(var i = indexPaths.count - 1; i >= 0; i--){
                // get the current indexPath
                var indexPath = indexPaths[i] as NSIndexPath
                
                // remove the meme from the saved memes array (in App Delegate)
                appDelegate.memes.removeAtIndex(indexPath.row)
                
                // remove the memes from the class's copy of the memes array
                memes.removeAtIndex(indexPath.row)
                
                // remove the item from the collection view
                collectionView?.deleteItemsAtIndexPaths([indexPath])
            }
        }
    }
    
    // function to show the detailed view controller
    func showDetailView(index: Int){
        
        // instantiate the view, set the properties and push
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        
        // set the meme to display and its index in the detailed view
        detailController.meme = memes[index]
        detailController.index = index
        
        // push the view controller into the view
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: @IBAction Functions
    
    // Handle the edit button being pressed
    @IBAction func editMemeTableView(sender: UIBarButtonItem) {
        // turn isEditing flag on
        isEditing = true
        
        // allow multiple selection of cells
        memeCollectionView.allowsMultipleSelection = true
        
        // set the button titles
        leftBarButton.title = "Delete"
        rightBarButton.title = "Cancel"
    }
    
    // handle the left navigation button being pressed
    @IBAction func leftNavBarButtonAction(sender: UIBarButtonItem) {
        
        // check if we are editing or going back
        if(isEditing){
            
            // if we are editing, then this button was pressed to delete the memes
            
            // delete the memes
            deleteMemes()
            
            // turn flag off
            isEditing = false
            
            // reset button to display "Back"
            leftBarButton.title = "Back"
        }
        else {
            // button was pressed when it said "Back"
            
            // go back to the Edit View View Controller
            let editVC = storyboard?.instantiateViewControllerWithIdentifier("EditView") as ViewController
            presentViewController(editVC, animated: true, completion: nil)
        }
    }
}