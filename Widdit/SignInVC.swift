//
//  SignInVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class SignInVC: UIViewController, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!

    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    var info : FBInfo?

    var avaImg: UIImage?
    var firstName: String?
    var emailTxt: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Font of Label
        label.font = UIFont(name: "Pacifico", size: 35)
        
        // Background Image
        let background = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        background.image = UIImage(named: "back")
        self.view.addSubview(background)
        background.layer.zPosition = -1
        
        
        self.btnFacebook.clipsToBounds = true
        self.btnFacebook.layer.cornerRadius = 8.0
        
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        configureFacebook()

    }
    
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    

    @IBAction func signInBtnTapped(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            let alert = UIAlertController(title: "Please", message: "Fill in all fields", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Fasho", style: .Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                
                // Remember user or save in App Memory did the user login or not
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // Call Login Function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            
            }
        }
    }
    
    
    //    MARK: FBSDKLoginButtonDelegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, picture.type(large), email, gender, bio"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            let strEmail: String = (result.objectForKey("email") as? String)!
            let strGender: String = (result.objectForKey("gender") as? String)!
            let avaImage: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)!
            
            
            self.info = FBInfo(image: avaImage, firstName: strFirstName, email: strEmail, gender: strGender)
            self.avaImg = avaImage
            self.firstName = strFirstName
            self.emailTxt = strEmail
            
            
            
//             Send Data to Server
            let user = PFUser()
            user.email = strEmail.lowercaseString
            user["firstName"] = strFirstName.lowercaseString
            user["gender"] = strGender

     
//             Convert image for sending to server
            let avaData = UIImageJPEGRepresentation(avaImage, 0.5)
            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
            user["ava"] = avaFile
            
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("FBSignUpVC") as! FBSignUpVC
            self.presentViewController(next, animated: true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    
                
            })

        }
  
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
 
    }
    
    //    MARK: Other Methods
    
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        btnFacebook.delegate = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 

    }
    

}
