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
    var delegate: ViewController? = nil
    
    var meme:Meme!
    var index:Int!
    var tabBar: CustomTabBar!
    
    override func viewDidLoad() {
        self.imageView.image = meme.memeImg;
        tabBar.setTabBarVisible(false, animated: true)
        // self.tabBarController?.setTabBarVisible()
    }
    
    @IBAction func goBack() {
        navigationController?.popToRootViewControllerAnimated(true)
        tabBar.setTabBarVisible(true, animated: true)
    }

    @IBAction func editMeme(sender: UIBarButtonItem) {
        let editVC = storyboard!.instantiateViewControllerWithIdentifier("editView") as ViewController
        self.presentViewController(editVC, animated: true, completion: {
            editVC.bottomTextField.text = self.meme.bottomText
            editVC.topTextField.text = self.meme.topText
            editVC.imageView.image = self.meme.originalImg
            editVC.imageView.frame.origin.x = self.meme.originalImgOriginX
            editVC.imageView.frame.origin.y = self.meme.originalImgOriginY
            editVC.setScrollView()
            editVC.scrollView.zoomScale = self.meme.zoomScale
            editVC.isEditing = true
            editVC.editingIndex = self.index
            editVC.cancelEdit.title = "Cancel"
        })
    }
    
    @IBAction func deleteMeme(){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.removeAtIndex(index)
        goBack()
    }
}