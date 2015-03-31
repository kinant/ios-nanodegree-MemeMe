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
    
    var originalH:CGFloat!
    var originalW:CGFloat!
    
    var bottomTextFieldConstraintY:NSLayoutConstraint!
    var topTextFieldConstraintY:NSLayoutConstraint!
    
    var ranOnce = false;
    var setConstraints: NSArray!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalH = imageView.frame.height
        originalW = imageView.frame.width
        
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
        
        setTextFieldPosition()
        
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
        setTextFieldPosition()
    }
    
    func swipeRight(){
        --templateIndex
        
        if(templateIndex < 0){
            templateIndex = templateImages.count
        }
        
        imageView.image = UIImage(named: "t\(templateIndex).jpg")
        setTextFieldPosition()
    }
    
    func save(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) {
        //Create the meme
        if completed {
            var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, original: imageView.image!, meme: memeImg)
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        mainToolbar.hidden = true
        navigationBar.hidden = true
        
        UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, false, 0.0)
        
        var rect = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - self.imageView.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.drawViewHierarchyInRect(rect,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
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
    func frameFromImage(image: UIImage, imageView: UIImageView)->CGRect {
        var imageRatio = image.size.width / image.size.height;
        
        var viewRatio = imageView.frame.size.width / imageView.frame.size.height;
        
        if(imageRatio < viewRatio)
        {
            var scale = imageView.frame.size.height / image.size.height;
            
            var width = scale * image.size.width;
            
            var topLeftX = (imageView.frame.size.width - width) * 0.5;
            
            return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
        }
        else
        {
            var scale = imageView.frame.size.width / image.size.width;
            
            var height = scale * image.size.height;
            
            var topLeftY = (imageView.frame.size.height - height) * 0.5;
            
            return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
        }
    }
    
    func setTextFieldPosition(){
        
        // var new_view = UIView()
        // new_view.backgroundColor = UIColor.redColor()
        // view.addSubview(new_view)
        
        //Don't forget this line
        // new_view.setTranslatesAutoresizingMaskIntoConstraints(false)
        // var newImage = UIImage(named: "2");
        if(ranOnce){
            view.removeConstraint(topTextFieldConstraintY)
            view.removeConstraint(bottomTextFieldConstraintY)
        }
        else {
            ranOnce = true
        }
        var frame = frameFromImage(imageView.image!, imageView: imageView)
        
        // imageView.image = newImage;
        
        /*
        println("================= ORIGINAL IMAGE =====================");
        println("x: \(imageView.frame.origin.x)");
        println("y: \(imageView.frame.origin.y)");
        println("h: \(newImage!.size.height)");
        println("w: \(newImage!.size.width)");
        println("======================================================");
        println("================= ASPECT FIT IMAGE =====================");
        println("x: \(frame.origin.x)");
        println("y: \(frame.origin.y)");
        println("h: \(frame.size.height)");
        println("w: \(frame.size.width)");
        println("======================================================");
        */
        
        var topL = self.topLayoutGuide
        
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // previousConstraintX = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        // view.addConstraint(previousConstraintX)
        
        topTextFieldConstraintY = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (frame.origin.y + 50))
        view.addConstraint(topTextFieldConstraintY)
        
        bottomTextFieldConstraintY = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (frame.origin.y + frame.height + 30))
        view.addConstraint(bottomTextFieldConstraintY)
        
    }
    
}