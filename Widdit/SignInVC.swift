//
//  SignInVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class SignInVC: UIViewController/*, FBSDKLoginButtonDelegate */{
    
    
    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var forgotPasswordBtn: UIButton!
//    @IBOutlet weak var signUpBtn: UIButton!
//    @IBOutlet weak var signInBtn: UIButton!
//    @IBOutlet weak var passwordTxt: UITextField!
//    @IBOutlet weak var usernameTxt: UITextField!

//    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    var info : FBInfo?

    var avaImg: UIImage?
    var firstName: String?
    var emailTxt: String?
    var user: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.WDTGrayBlueColor()
        
        let usernameTF = UITextField()
        usernameTF.WDTRoundedWhite(nil, height: 50)
        usernameTF.WDTFontSettings("Enter Username")
        usernameTF.autocapitalizationType = .None
        
        view.addSubview(usernameTF)
        usernameTF.snp_makeConstraints { (make) in
            make.top.equalTo(label.snp_bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(50)
        }
        
        
        let signupButton: UIButton = UIButton(type: .Custom)
        signupButton.WDTButtonStyle(UIColor.whiteColor(), title: "Sign Up")
//        signupButton.addTarget(self, action: #selector(signupButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(signupButton)
        signupButton.snp_makeConstraints { (make) in
            make.left.equalTo(view.snp_centerX).offset(10)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }

        // Font of Label
        label.font = UIFont(name: "Pacifico", size: 35)
        
           
//        configureFacebook()

    }
    
//
//    @IBAction func signInBtnTapped(sender: AnyObject) {
//        
//        self.view.endEditing(true)
//        
//        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
//            
//            let alert = UIAlertController(title: "Please", message: "Fill in all fields", preferredStyle: .Alert)
//            let ok = UIAlertAction(title: "Fasho", style: .Cancel, handler: nil)
//            alert.addAction(ok)
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//        
//        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user: PFUser?, error: NSError?) -> Void in
//            if error == nil {
//                
//                // Remember user or save in App Memory did the user login or not
//                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                
//                // Call Login Function from AppDelegate.swift class
//                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                appDelegate.login()
//            } else {
//                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
//                let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
//                alert.addAction(ok)
//                self.presentViewController(alert, animated: true, completion: nil)
//            
//            }
//        }
//    }
//    
//    func loginToFacebook(sender: AnyObject?) {
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"], block: { (user, err) in
//            if err == nil {
//                if let user = user {
//                    if user.isNew {
//                        print("User is new lets segue to customizations")
//
//                    } else {
//                        print("User is in our DB already")
//                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let myTabBar = storyboard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
//                        self.view.window?.rootViewController = myTabBar
//                    }
//                }
//            }
//        })
//    }
//    
//    //    MARK: FBSDKLoginButtonDelegate Methods
//
//    //WE NEED TO USE THIS BUTTON OR A CUSTOM IMAGE FOR IT
//    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
//    {
//        print("User Logged In")
//        if ((error) != nil)
//        {
//            // Process error
//            print(error)
//        } else if result.isCancelled {
//            // Handle cancellations
//            print("User cancelled")
//        } else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("email")
//            {
//                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler { (connection, result, error) -> Void in
//
//                    if result.count > 0 {
//
//                        let userQuery = PFQuery(className: "_User")
//
//                        userQuery.whereKey("email", equalTo: result.valueForKey("email") as! String)
//
//                        userQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, err) in
//                            if err == nil {
//                                if let object = objects!.first {
//                                    print("User is in our DB")
//                                    let user = object as! PFUser
//                                    PFFacebookUtils.linkUserInBackground(user, withAccessToken: FBSDKAccessToken.currentAccessToken())
//                                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let myTabBar = storyboard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
//                                    self.view.window?.rootViewController = myTabBar
//                                } else {
//                                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
////                                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
//                                    let strEmail: String = (result.objectForKey("email") as? String)!
////                                    let strGender: String = (result.objectForKey("gender") as? String)!
//                                    let userID = result.valueForKey("id") as! String
//                                    let avaImage: UIImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")!)!)!
//
//
//                                    self.info = FBInfo(image: avaImage, firstName: strFirstName, email: strEmail, gender: "")
//                                    print("FBINFO: \(self.info)")
//                                    self.avaImg = avaImage
//                                    self.firstName = strFirstName
//                                    self.emailTxt = strEmail
//
//
//
//
//
//                                    //             Send Data to Server
//                                    let user = PFUser()
//                                    user.email = strEmail.lowercaseString
//                                    user["firstName"] = strFirstName.lowercaseString
////                                    user["gender"] = strGender
//
//
//                                    //             Convert image for sending to server
//                                    let avaData = UIImageJPEGRepresentation(avaImage, 0.5)
//                                    let avaFile = PFFile(name: "ava.jpg", data: avaData!)
//                                    user["ava"] = avaFile
//
//                                    self.user = user
//
//                                    self.performSegueWithIdentifier("FBVerifyPin", sender: self)
//
//                                    
//                                    print("Access token: \(FBSDKAccessToken.currentAccessToken())")
//
//                                    
//                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                        
//                                        
//                                    })
//                                }
//                            } else {
//                                print(err)
//                            }
//                        })
//                    } else {
//                        print("Error completing facebook signup")
//                    }
//                    
//                }
//            }
//        }
//    }
//
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
//    {
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()
//        
// 
//    }
//    
//    //    MARK: Other Methods
//    
//    func configureFacebook()
//    {
//        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
//        btnFacebook.delegate = self
//        btnFacebook.loginBehavior = FBSDKLoginBehavior.SystemAccount
//    }
//
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "FBVerifyPin" {
//            let destVC = segue.destinationViewController as! TextVerifyViewController
//            destVC.userInfo = self.info
//
//            destVC.user = self.user
//
//            destVC.FBAccessToken = FBSDKAccessToken.currentAccessToken()
//        }
//    }


}
