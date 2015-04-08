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
    
    override func viewDidLoad() {
        self.imageView.image = meme.memeImg;
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        let editVC = storyboard!.instantiateViewControllerWithIdentifier("editView") as ViewController
        self.presentViewController(editVC, animated: true, completion: {
            editVC.bottomTextField.text = self.meme.bottomText
            editVC.topTextField.text = self.meme.topText
            editVC.imageView.image = self.meme.originalImg
            editVC.isEditing = true
            editVC.editingIndex = self.index
            editVC.cancelEdit.title = "Cancel"
        })
    }
}