//
//  EnterVerifyPinViewController.swift
//  Widdit
//
//  Created by Ethan Thomas on 5/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import SinchVerification
import ParseFacebookUtilsV4
import Parse

class EnterVerifyPinViewController: UIViewController {
    var verification: Verification!
    var phoneNumber: String!
    var userInfo: FBInfo!
    var user: PFUser!
    var FBAccessToken: FBSDKAccessToken!
    var isSignIn: Bool?

    @IBOutlet var pinText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func verifyPin(sender: UIButton) {
        verification.verify(pinText.text!) { (success, err) in
            if success {
                print("Successfully registered!")
                if self.FBAccessToken != nil {
                    self.performSegueWithIdentifier("segueToFBSignup", sender: self)
                } else if self.isSignIn == true {
                    let query = PFQuery(className: "_User")
                    print(self.phoneNumber)
                    query.whereKey("phoneNumber", equalTo: self.phoneNumber)

                    query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error) in
                        if error == nil {
                            if objects?.count > 0 {
                                let object = objects?.first as! PFUser
                                print(objects)
                                let alert = UIAlertController(title: "Enter Password", message: "Please enter your password for the account: \(object.valueForKey("username")!)", preferredStyle: .Alert)
                                alert.addTextFieldWithConfigurationHandler({ (textfield) in
                                    textfield.secureTextEntry = true
                                })
                                let ok = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                                    print(alert.textFields![0].text)
                                    print(object.valueForKey("username") as! String)
                                    PFUser.logInWithUsernameInBackground((object.valueForKey("username") as! String), password: (alert.textFields![0].text)!, block: { (user, err) in
                                        if err == nil {
                                            print("Successfully logged in!")
                                            print("Current user: \(PFUser.currentUser())")
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBar") as! UITabBarController
                                            self.presentViewController(vc, animated: true, completion: nil)
                                        } else {
                                            print("Error logging in user: \(err)")
                                        }
                                    })
                                })
                                alert.addAction(ok)
                                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                                alert.addAction(cancel)
                                self.presentViewController(alert, animated: true, completion: nil)
                            } else {
                                print("Couldn't find user")
                                let alert = UIAlertController(title: "Hey!", message: "We couldn't find a user for this phone number. Please try again", preferredStyle: .Alert)
                                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                                alert.addAction(ok)
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        } else {
                            print("Error logging in user: \(error)")
                        }
                    })
                } else {
                    self.performSegueWithIdentifier("segueToSignUp", sender: self)
                }
            } else {
                print("Error authentication pin: \(err)")
                let alert = UIAlertController(title: "Error verifying PIN", message: err!.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToSignUp" {
            let destVC = segue.destinationViewController as! SignUpVC
            destVC.phoneNumber = phoneNumber
        } else if segue.identifier == "segueToFBSignup" {
            let destVC = segue.destinationViewController as! FBSignUpVC
            destVC.info = userInfo
            destVC.FBAccessToken = FBAccessToken
            destVC.user = user
            destVC.phoneNumber = phoneNumber
        }
    }
    
    @IBAction func closePIN(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
