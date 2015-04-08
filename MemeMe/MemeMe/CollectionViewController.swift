//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/31/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import Foundation

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    
    var memes:[Meme]!
    
    var isEditing = false
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet var memeCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as CustomCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.memeImage.image = meme.memeImg
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        if(!isEditing){
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
            detailController.meme = self.memes[indexPath.item]
            detailController.index = indexPath.item
            presentViewController(detailController, animated: true, completion: nil)
        }
        else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as CustomCollectionViewCell
            cell.checkMark.hidden = false
            cell.isSelected = true
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CustomCollectionViewCell
        cell.checkMark.hidden = true
        cell.isSelected = false
    }
    
    func deleteMemes(){
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            for(var i = indexPaths.count - 1; i >= 0; i--){
                var indexPath = indexPaths[i] as NSIndexPath
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as AppDelegate
                appDelegate.memes.removeAtIndex(indexPath.row)
                memes.removeAtIndex(indexPath.row)
                collectionView?.deleteItemsAtIndexPaths([indexPath])
            }
        }
    }
    
    @IBAction func editMemeTableView(sender: UIBarButtonItem) {
        isEditing = true
        memeCollectionView.allowsMultipleSelection = true
        // setTabBarVisible(false, animated: false)
        leftBarButton.title = "Delete"
        rightBarButton.title = "Cancel"
    }
    
    @IBAction func leftNavBarButtonAction(sender: UIBarButtonItem) {
        if(isEditing){
            deleteMemes()
            isEditing = false
            leftBarButton.title = "Back"
        }
        else {
            let editVC = storyboard?.instantiateViewControllerWithIdentifier("editView") as ViewController
            presentViewController(editVC, animated: true, completion: nil)
        }
    }
}