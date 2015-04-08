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
    
    @IBOutlet weak var navTitle: UINavigationItem!
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
    
    var memes: [Meme]!
    
    // var editingMeme:Meme!
    var editingIndex:Int!
    
    var isEditing = false
    
    @IBOutlet weak var cancelEdit: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
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
        
        topTextFieldConstraintY = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 150)
        view.addConstraint(topTextFieldConstraintY)
        
        bottomTextFieldConstraintY = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -150)
        view.addConstraint(bottomTextFieldConstraintY)
        
        // http://www.avocarrot.com/blog/implement-gesture-recognizers-swift/
        self.imageView.userInteractionEnabled = true
        
        self.imageView.addGestureRecognizer(swipeRecRight)
        swipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRecRight.addTarget(self, action: "swipeRight")
        
        self.imageView.addGestureRecognizer(swipeRecLeft)
        swipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRecLeft.addTarget(self, action: "swipeLeft")
        
        navTitle.title = "MemeMe"
        self.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            textField.text = textField.text.uppercaseString
        return true
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
        textField.text = textField.text.uppercaseString
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
            //imageView.contentMode = UIViewContentMode.ScaleAspectFill;
            self.imageView.image = image
            setTextFieldPosition()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: UIBarButtonItem) {
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
    
    func goToTabBarView(){
        let tabBarVC = storyboard?.instantiateViewControllerWithIdentifier("tabBarView") as UITabBarController
        presentViewController(tabBarVC, animated: false, completion: nil)
    }
    
    func save(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) {
        //Create the meme
        if completed {
            
            var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, original: imageView.image!, meme: memeImg)
            
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as AppDelegate
            
            if(!isEditing){
                appDelegate.memes.append(meme)
            }
            else
            {
                appDelegate.memes[editingIndex] = meme
                isEditing = false
            }
            
            goToTabBarView()
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        var additive = CGFloat(64.0)
        
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
            additive = 44
        }

        mainToolbar.hidden = true
        navigationBar.hidden = true
        
        let frame = frameFromImage(imageView.image!, imageView: imageView)!
        
        UIGraphicsBeginImageContext(frame.size)
        
        var rectangle = CGRectMake(self.view.frame.origin.x - frame.origin.x, self.view.frame.origin.y - frame.origin.y - additive, self.view.frame.width, self.view.frame.height)
        
        self.view.drawViewHierarchyInRect(rectangle, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        mainToolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        if let testForImage = imageView.image {
            memeImg = generateMemedImage()
            let objectsToShare = [memeImg]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        
            activityVC.completionWithItemsHandler = save
        }
        else {
            showAlert()
        }
    }
    
    func frameFromImage(image2: UIImage?, imageView: UIImageView)->CGRect? {
        
        if let image = image2? {
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
        else{
            return nil
        }
    }
    
    func setTextFieldPosition(){
        
        view.removeConstraint(topTextFieldConstraintY)
        view.removeConstraint(bottomTextFieldConstraintY)

        var frame : CGRect!
        
        if let tryFrame = frameFromImage(imageView.image?, imageView: imageView) {
            frame = tryFrame
        }
        else
        {
            frame = CGRectMake(0, 84, self.view.frame.width, self.view.frame.height - 250);
        }
        
        var topL = self.topLayoutGuide
        
        topTextFieldConstraintY = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (frame.origin.y + 50))
        view.addConstraint(topTextFieldConstraintY)
        
        bottomTextFieldConstraintY = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (frame.origin.y + frame.height + 30))
        view.addConstraint(bottomTextFieldConstraintY)
    }
    
    
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        
        cancelEdit.title = ""
        
        let detailedViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        
        detailedViewController.meme = memes[editingIndex]
        detailedViewController.index = editingIndex
        presentViewController(detailedViewController, animated: true, completion: nil)
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Error", message:
            "You Must Select an Image First!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}