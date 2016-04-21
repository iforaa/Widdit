//
//  EditVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    // UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    // pickerView & pickerData
    var genderPicker : UIPickerView!
    let genders = ["male","female"]
    
    // value to hold keyboard frmae size
    var keyboard = CGRect()

    override func viewDidLoad() {
        super.viewDidLoad()
            
            // create picker
            genderPicker = UIPickerView()
            genderPicker.dataSource = self
            genderPicker.delegate = self
            genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
            genderPicker.showsSelectionIndicator = true
            genderTxt.inputView = genderPicker
            
            // check notifications of keyboard - shown or not
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
            
            // tap to hide keyboard
            let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
            hideTap.numberOfTapsRequired = 1
            self.view.userInteractionEnabled = true
            self.view.addGestureRecognizer(hideTap)
            
            // tap to choose image
            let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
            avaTap.numberOfTapsRequired = 1
            avaImg.userInteractionEnabled = true
            avaImg.addGestureRecognizer(avaTap)

            
            // call information function
            information()
        }
        
        
        // func to hide keyboard
        func hideKeyboard() {
            self.view.endEditing(true)
        }
 
        // func when keyboard is shown
        func keyboardWillShow(notification: NSNotification) {
            
            // define keyboard frame size
            keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
            
            // move up with animation
            UIView.animateWithDuration(0.4) { () -> Void in
                self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
            }
        }
        
        
        // func when keyboard is hidden
        func keyboardWillHide(notification: NSNotification) {
            
            // move down with animation
            UIView.animateWithDuration(0.4) { () -> Void in
                self.scrollView.contentSize.height = 0
            }
        }
        
        
        // func to call UIImagePickerController
        func loadImg (recognizer : UITapGestureRecognizer) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
        
        
        // method to finilize our actions with UIImagePickerController
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        

        
        
        // user information function
        func information() {
            
            // receive profile picture
            let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
            ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                self.avaImg.image = UIImage(data: data!)
            }
            
            // receive text information
            usernameTxt.text = PFUser.currentUser()?.username
            firstNameTxt.text = PFUser.currentUser()?.objectForKey("firstName") as? String
            bioTxt.text = PFUser.currentUser()?.objectForKey("bio") as? String
            
            emailTxt.text = PFUser.currentUser()?.objectForKey("email") as? String
            genderTxt.text = PFUser.currentUser()?.objectForKey("gender") as? String
        }
        
        
        // regex restrictions for email textfield
        func validateEmail (email : String) -> Bool {
            let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
            let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
            let result = range != nil ? true : false
            return result
        }
        
        
        // alert message function
        func alert (error: String, message : String) {
            let alert = UIAlertController(title: error, message: message, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        // clicked save button
        @IBAction func saveBtnTapped (sender: AnyObject) {
            
//            // if incorrect email according to regex
//            if !validateEmail(emailTxt.text!) {
//                alert("Incorrect email", message: "please provide correct email address")
//                return
//            }
            
            
            // save filled in information
            let user = PFUser.currentUser()!
            user.username = usernameTxt.text?.lowercaseString
            user.email = emailTxt.text?.lowercaseString
            user["firstName"] = firstNameTxt.text?.lowercaseString
            user["bio"] = bioTxt.text

            
            // if "gender" is empty, send empty data, else entered data
            if genderTxt.text!.isEmpty {
                user["gender"] = ""
            } else {
                user["gender"] = genderTxt.text
            }
            
            // send profile picture
            let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
            user["ava"] = avaFile
            
            // send filled information to server
            user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) -> Void in
                if success{
                    
                    // hide keyboard
                    self.view.endEditing(true)
                    
                    // dismiss editVC
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    // send notification to homeVC to be reloaded
                    NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }
        
        
        // clicked cancel button
        @IBAction func cancelBtnTapped (sender: AnyObject) {
            self.view.endEditing(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        // PICKER VIEW METHODS
        // picker comp numb
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // picker text numb
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return genders.count
        }
        
        // picker text config
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return genders[row]
        }
        
        // picker did selected some value from it
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            genderTxt.text = genders[row]
            self.view.endEditing(true)
        }
        
        
}