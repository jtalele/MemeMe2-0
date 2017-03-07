			//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Jitendra Talele on 4/25/16.
//  Copyright © 2016 talele. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK: Variable Declarations
   
    @IBOutlet var myUIView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    @IBOutlet weak var topNavigatonBarTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var albumsButton: UIBarButtonItem!
    
    
    //MARK:Custom Variable Declarations
    var defaultViewYOrigin:CGFloat?
    var defaultTopNavigationBarTopConstraint:CGFloat?
    
    
    //Placeholder to save memes on copy only for simulator test mode
    var simulatorTestMode=false
    
    //MARK:View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeTextFields()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled=UIImagePickerController.isSourceTypeAvailable(.camera)
        cameraButton.tag=TagManager().getTagIdForName("CAMERA_BUTTON")
        
        albumsButton.tag=TagManager().getTagIdForName("ALBUMS_BUTTON")
        
        defaultViewYOrigin=myUIView.frame.origin.y
        defaultTopNavigationBarTopConstraint=topNavigatonBarTopConstraint.constant
        
        
        
        if(imageView.image == nil){
            shareButton.isEnabled=false

        }
        else{
            shareButton.isEnabled=true
            cancelButton.isEnabled=true
        }

        
        subscribeToKeyboardNotifications()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unSubscribeFromKeyboardNotifications()

    }
    
    
    
    
    //MARK:UIView BUtton Actions
    
    @IBAction func getImageAction(_ sender:AnyObject){
        
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        
        if(sender.tag == TagManager().getTagIdForName("CAMERA_BUTTON")){
            imagePicker.sourceType = .camera
        }
        if(sender.tag == TagManager().getTagIdForName("ALBUMS_BUTTON")){
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)

    }
    
        
    @IBAction func shareButton(_ sender: AnyObject) {
        
        let myMemeImage:UIImage=generateMemedImage()
        
        let myActivityViewController=UIActivityViewController(activityItems: [myMemeImage], applicationActivities: nil)
        
        present(myActivityViewController, animated: true, completion: nil)
        
        myActivityViewController.completionWithItemsHandler={
            (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            //Activity is to share the meme
            
  
            self.save()
            self.dismiss(animated: true, completion: nil)
                
   
        }

    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        imageView.image=nil
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK:UIImagePickerDelegate Implementations
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let selectedImage=info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image=selectedImage
            dismiss(animated: true, completion: nil)

        }
    }


    //MARK:UITextFieldDelegate Implementations
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //To clear default values from text fields
        clearDefaultTextFromTextFields(textField)

    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag==TagManager().getTagIdForName("TOP_TEXTFIELD") && textField.text==""){
            textField.text="TOP"
        }
        if(textField.tag==TagManager().getTagIdForName("BOTTOM_TEXTFIELD") && textField.text==""){
            textField.text="BOTTOM"
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //MARK: Custom Functions
    
    
    func save(){
        
        //Create the meme using Struct
        
        //Link for reference
        //http://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
        
        
        let meme=Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        
        //Save the meme to shared data model stored in AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.savedMemes.append(meme)
        
    }
    
    
  
    func generateMemedImage()->UIImage {
        
        //Hide Tool bar and Nav bar
        
        topNavigationBar.isHidden=true
        bottomToolBar.isHidden=true
        
        //Render View to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Tool bar and Nav bar
        topNavigationBar.isHidden=false
        bottomToolBar.isHidden=false
        
        return memedImage
        
    }
    
    
    func clearDefaultTextFromTextFields(_ textField:UITextField){

        if(textField.text=="TOP" || textField.text=="BOTTOM"){
            textField.text=""
        }
        
        
    }
    
    
    
    func initializeTextFields(){
        
        let memeTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeColorAttributeName : UIColor.black,
            NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName:-2.0
        ] as [String : Any]
        
        /*
        A special note about NSForegroundColorAttributeName
        
        NSStrokeWidthAttributeName is interpreted as a mode; it indicates whether the attributed string is to be filled, stroked, or both. Specifically, a zero value displays a fill only, while a positive value displays a stroke only. A negative value allows displaying both a fill and stroke.

        NSStrokeWidthAttributeName: 1.0
        the font is stroked only and not filled, resulting in an "outline font". You'll want to set
        
        NSStrokeWidthAttributeName: -1.0
        instead so that the font is stroked and filled.
        
        NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
        */
        
        
        topTextField.delegate=self
        topTextField.defaultTextAttributes=memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.tag=TagManager().getTagIdForName("TOP_TEXTFIELD")
        topTextField.text="TOP"

        
        bottomTextField.delegate=self
        bottomTextField.defaultTextAttributes=memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.tag=TagManager().getTagIdForName("BOTTOM_TEXTFIELD")
        bottomTextField.text="BOTTOM"
    }
    
    
    
    func subscribeToKeyboardNotifications(){
        
        //Subsribe to UIKeyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Subscriber to UIKeyboardWillHideNotification
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unSubscribeFromKeyboardNotifications(){
       
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(_ notification:Notification){
        
        //Move the view up on y axis by keyboard's height
        if(topTextField.isFirstResponder==false && myUIView.frame.origin.y == defaultViewYOrigin){
            topNavigatonBarTopConstraint.constant = defaultTopNavigationBarTopConstraint! - getKeyboardHeight(notification)
            myUIView.frame.origin.y = defaultViewYOrigin! - getKeyboardHeight(notification)
        }
        
    }
    
    
    func keyboardWillHide(_ notification:Notification){
        
        //Restore view's original y origin
        
        if(topTextField.isFirstResponder==false && myUIView.frame.origin.y != defaultViewYOrigin){
            topNavigatonBarTopConstraint.constant = defaultTopNavigationBarTopConstraint!
            myUIView.frame.origin.y = defaultViewYOrigin!
        }

    }
    
    
    
    func getKeyboardHeight(_ notification:Notification)->CGFloat{
        
        var keyBoardSize=NSValue()
        
        keyBoardSize=notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue

 
        //UIKeyboardFrameEndUserInfoKey vs UIKeyboardFrameBeginUserInfoKey - The start frame is where the keyboard is at the beginning of the animation: offscreen if the keyboard is being shown, or onscreen if the keyboard is being hidden. The end frame is where the keyboard will be at the end of the animation: vice versa
        
        return keyBoardSize.cgRectValue.height
        
    }
    
    
}

