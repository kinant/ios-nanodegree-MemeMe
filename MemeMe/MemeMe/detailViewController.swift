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
    var senderIsEditView = false
    var navController: UINavigationBar!
    
    override func viewDidLoad() {
        self.imageView.image = meme.memeImg;
        
        if(!senderIsEditView){
            // tabBar.setTabBarVisible(false, animated: true)
        }
        // self.tabBarController?.setTabBarVisible()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Notice that this code works for both Scissors and Paper
        //let controller = segue.destinationViewController as ViewController
        //controller.setForEditing(self.meme, index: self.index)
    }
    
    @IBAction func goBack() {
        navigationController?.popToRootViewControllerAnimated(true)
        if(!senderIsEditView){
            // tabBar.setTabBarVisible(true, animated: true)
        }
    }

    @IBAction func editMeme(sender: UIBarButtonItem) {
        // var storyboard = UIStoryboard (name: "Main", bundle: nil)
        // var resultVC = storyboard.instantiateViewControllerWithIdentifier("EditView") as ViewController
        // performSegueWithIdentifier(<#identifier: String?#>, sender: <#AnyObject?#>)
        var editVC = storyboard?.instantiateViewControllerWithIdentifier("EditView") as ViewController
        presentViewController(editVC, animated: true, completion: {editVC.setForEditing(self.meme, index: self.index)})
    }
    
    @IBAction func deleteMeme(){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.removeAtIndex(index)
        goBack()
    }
}