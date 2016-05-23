//
//  SignUpVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    
    var scrollViewHeight : CGFloat = 0
    
    var keyboard = CGRect()

    var phoneNumber: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Scrollview Frame Size
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        // Check notifications if keyboard is shown or not
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        
        // Declare Hide Keyoard Tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // Rounded Image
        avaImg.layer.cornerRadius = 8.0
        avaImg.clipsToBounds = true
        
        // Declare Select Image
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        
        // VC Background Image
        let background = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        background.image = UIImage(named: "back")
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        


        
    }
    
    func loadImg(recognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideKeyboardTap(recognizer : UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if self.usernameTxt.text?.characters.count > 16 {
            return false
        } else {
            return true
        }
    }
    
    func showKeyboard(notification : NSNotification) {
        
        // define keyboard size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        // move up UI
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
        
    }
    
    func hideKeyboard(notification: NSNotification) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
        
    }
    
    @IBAction func signUpBtnTapped(sender: AnyObject) {
        
        print("Sign Up Pressed")
        
        self.view.endEditing(true)
        
        // If fields are empty
        
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || emailTxt.text!.isEmpty || firstNameTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Yo", message: "Fill out all the stuff", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Fasho", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        // Passwords do not match
        if passwordTxt.text != repeatPasswordTxt.text {
            
            let alert = UIAlertController(title: "Yo", message: "Your passwords don't match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "Got it", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // Send Data to Server
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text
        user["firstName"] = firstNameTxt.text?.lowercaseString
        
        // In Edit Profile this will be assigned
        user["phoneNumber"] = ""
        user["gender"] = ""
        user["location"] = ""
        user["bio"] = ""
        user["phoneNumber"] = phoneNumber
        
        // Convert image for sending to server
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("registered")
                // Remember Logged User
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            } else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    
    }
    
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        
        print("Cancel Pressed")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    
    }
    
    

  
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToVerify" {
            let destVC = segue.destinationViewController as! TextVerifyViewController
        }
    }

}
