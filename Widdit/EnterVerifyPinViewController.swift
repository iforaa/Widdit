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
