//
//  ViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/26/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var colorPick: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var mainToolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let swipeRecRight = UISwipeGestureRecognizer()
    let swipeRecLeft = UISwipeGestureRecognizer()
    
    let templateImages = [
        "t1.jpg",
        "t2.jpg",
        "t3.jpg",
        "t4.jpg",
        "t5.jpg",
        "t6.jpg"
    ]
    
    var templateIndex = 0
    
    var editingBottom = false
    
    var memeImg: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
        
        //imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName :UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        ]
        
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        self.topTextField.tag = 1
        self.bottomTextField.tag = 2
        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center
        
        // http://www.avocarrot.com/blog/implement-gesture-recognizers-swift/
        self.imageView.userInteractionEnabled = true
        
        self.imageView.addGestureRecognizer(swipeRecRight)
        swipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRecRight.addTarget(self, action: "swipeRight")
        
        self.imageView.addGestureRecognizer(swipeRecLeft)
        swipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRecLeft.addTarget(self, action: "swipeLeft")
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(textField.text == "TOP"){
            textField.text = ""
        }
        else if(textField.text == "BOTTOM"){
            textField.text = ""
        }
        
        if(textField.tag == 2){
            editingBottom = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text == ""){
            
            textField.text = "BOTTOM"
            
            if(textField.tag == 1){
                textField.text = "TOP"
            }
        }
        textField.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(editingBottom){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(editingBottom){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        editingBottom = false
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func colorPickerButton(sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("colorPickerPopover") as ColorPickerViewController
        
        popoverVC.modalPresentationStyle = .Popover
        
        popoverVC.preferredContentSize = CGSizeMake(284, 446)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverVC.delegate = self
        }

        presentViewController(popoverVC, animated: false, completion: nil)
        
    }
    
    @IBAction func fontPickerButton(sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("fontPickerPopover") as FontPickerViewController
        
        popoverVC.modalPresentationStyle = .Popover
        
        popoverVC.preferredContentSize = CGSizeMake(284, 446)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        presentViewController(popoverVC, animated: false, completion: nil)
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    func setButtonColor (color: UIColor) {
        self.topTextField.textColor = color
        self.bottomTextField.textColor  = color
        colorPick.setTitleColor(color, forState: UIControlState.Normal)
    }
    
    func setTextFont(font: UIFont){
        topTextField.font = font
        bottomTextField.font = font
    }
    
    func swipeLeft(){
        ++templateIndex
        if(templateIndex > templateImages.count){
            templateIndex = 0
        }
        imageView.image = UIImage(named: "t\(templateIndex).jpg")
        println(templateIndex)
    }
    
    func swipeRight(){
        --templateIndex
        
        if(templateIndex < 0){
            templateIndex = templateImages.count
        }
        
        imageView.image = UIImage(named: "t\(templateIndex).jpg")
        println(templateIndex)
    }
    
    func save(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) {
        //Create the meme
        if completed {
            var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, original: imageView.image!, meme: memeImg)
            // self.dismissViewControllerAnimated(false, completion: {})
        }
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        mainToolbar.hidden = true
        navigationBar.hidden = true
        
        // Render view to an image
        var rect = CGRect(x: self.imageView.frame.origin.x, y: self.imageView.frame.origin.y - self.navigationBar.frame.height - 20, width: self.imageView.frame.width, height: self.imageView.frame.height)
    
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        
        self.view.drawViewHierarchyInRect(rect,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        mainToolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIButton) {
        memeImg = generateMemedImage()
        let objectsToShare = [memeImg]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = save
    }
    
}