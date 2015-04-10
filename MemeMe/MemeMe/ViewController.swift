//
//  ViewController.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/26/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var colorPick: UIButton!
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    var imageView = UIImageView()
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var mainToolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let swipeRecRight = UISwipeGestureRecognizer()
    let swipeRecLeft = UISwipeGestureRecognizer()
    
    var editingBottom = false
    
    var memeImg: UIImage!
    
    // var originalH:CGFloat!
    // var originalW:CGFloat!
    
    // var bottomTextFieldConstraintY:NSLayoutConstraint!
    // var topTextFieldConstraintY:NSLayoutConstraint!
    
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
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
        fillTemplates()
        
        scrollView.delegate = self
        
        // add imageView
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.width)
        
        imageView.userInteractionEnabled = true
        
        scrollView.addSubview(imageView)
        
        // add text fields
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName :UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        ]
        
        var rectangle = CGRect(x: 0, y: 0, width: 200, height: 40)
        
        self.topTextField = UITextField(frame: rectangle)
        self.bottomTextField = UITextField(frame: rectangle)
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
        
        topTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.adjustsFontSizeToFitWidth = true
        
        topTextField.minimumFontSize = 8
        bottomTextField.minimumFontSize = 8
        
        view.addSubview(topTextField)
        view.addSubview(bottomTextField)
        
        topTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var topTextFieldConstraintY = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.imageView, attribute: NSLayoutAttribute.Top, multiplier: 0, constant: 150)
        view.addConstraint(topTextFieldConstraintY)
        
        var bottomTextFieldConstraintY = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -150)
        view.addConstraint(bottomTextFieldConstraintY)
        
        var topTextFieldConstraintX = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(topTextFieldConstraintX)
        
        // http://stackoverflow.com/questions/28252583/how-do-i-set-the-constraint-of-width-programmatically-in-swift
        
        var topTextFieldWidth = NSLayoutConstraint (item: topTextField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,multiplier: 1, constant: self.view.frame.width - 40)
        self.view.addConstraint(topTextFieldWidth)
        
        var bottomTextFieldWidth = NSLayoutConstraint (item: bottomTextField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,multiplier: 1, constant: self.view.frame.width - 40)
        self.view.addConstraint(bottomTextFieldWidth)
        
        var bottomTextFieldConstraintX = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(bottomTextFieldConstraintX)
        
        navTitle.title = "MemeMe"
        
        cancelEdit.title = ""
        
        println(memes.count)
        
        if(memes.count == 0) {
            leftBarButton.enabled = false
        }
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
            setScrollView()
            centerScrollViewContents()
            leftBarButton.enabled = true
            //setTextFieldPosition()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setScrollView(){
        var image = imageView.image
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        
        scrollView.contentSize = image!.size
        
        // zoom factors
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        
        // get minimum scale
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2
        scrollView.zoomScale = minScale
    }
    
    func centerScrollViewContents(){
        
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if(contentsFrame.size.width < boundsSize.width){
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }
        else {
            contentsFrame.origin.x = 0
        }
        
        if(contentsFrame.size.height < boundsSize.height){
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }
        else {
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func pickImage(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        // pickerController.navigationBar.tintColor = UIColor.orangeColor()
        // pickerController.view.backgroundColor = UIColor.orangeColor()
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
    
    func goToTabBarView(){
        let tabBarVC = storyboard?.instantiateViewControllerWithIdentifier("tabBarView") as UITabBarController
        presentViewController(tabBarVC, animated: false, completion: nil)
    }
    
    func save(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) {
        //Create the meme
        if completed {
            
            var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, original: imageView.image!, originalX: imageView.frame.origin.x, originalY: imageView.frame.origin.y, zoom: self.scrollView.zoomScale, meme: memeImg)
            
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
        
        let frame = scrollView.frame
        
        UIGraphicsBeginImageContext(frame.size)
        
        var rectangle = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - 44 - additive - 20, self.scrollView.frame.width, self.scrollView.frame.height + 64 + 44)
        
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
    
    
    @IBAction func viewTemplates(sender: UIBarButtonItem) {
        let templateVC = storyboard?.instantiateViewControllerWithIdentifier("TemplatesTableView") as TemplatesTableViewController
        
        self.presentViewController(templateVC, animated: true, completion: nil)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //setTextFieldPosition()
    }
}