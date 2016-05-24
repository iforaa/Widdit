//
//  TextVerifyViewController.swift
//  Widdit
//
//  Created by Ethan Thomas on 5/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import SinchVerification
import Parse
import ParseFacebookUtilsV4

class TextVerifyViewController: UIViewController {


    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var spinner: UIActivityIndicatorView!

    //properties
    var verification: Verification!
    var applicationKey = "dcca03d9-54fd-4285-95de-3288274900ec"
    var userInfo: FBInfo!
    var user: PFUser!
    var FBAccessToken: FBSDKAccessToken!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enterPin" {
            let enterCodeVC = segue.destinationViewController as! EnterVerifyPinViewController
            enterCodeVC.verification = self.verification
            enterCodeVC.phoneNumber = phoneNumber.text!
        } else if segue.identifier == "verifyPinFB" {
            let enterCodeVC = segue.destinationViewController as! EnterVerifyPinViewController
            enterCodeVC.verification = self.verification
            enterCodeVC.phoneNumber = phoneNumber.text!
            enterCodeVC.FBAccessToken = FBAccessToken
            enterCodeVC.userInfo = userInfo
            enterCodeVC.user = user
        }
    }

    @IBAction func verifySMS(sender: UIButton) {
        verification = SMSVerification(applicationKey: applicationKey, phoneNumber: phoneNumber.text!)
        self.spinner.startAnimating()
        verification.initiate { (success, err) in
            if success {
                self.spinner.stopAnimating()
                if self.FBAccessToken != nil {
                    self.performSegueWithIdentifier("verifyPinFB", sender: self)
                } else {
                    self.performSegueWithIdentifier("enterPin", sender: self)
                }
            } else {
                self.spinner.stopAnimating()
                print("Error sending sms: \(err)")
                let alert = UIAlertController(title: "Error sending SMS", message: err!.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func calloutVerification(sender: UIButton) {
        verification = CalloutVerification(applicationKey: applicationKey, phoneNumber: phoneNumber.text!)
        self.spinner.startAnimating()
        verification.initiate { (success, err) in
            if success {
                print("Success!")
                self.spinner.stopAnimating()
                self.statusLabel.text = "Verified!"
            } else {
                self.spinner.stopAnimating()
                print("Error sending callout: \(err!.localizedDescription)")
                let alert = UIAlertController(title: "Uh oh!", message: err!.localizedDescription, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func dismissVerify(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        FBSDKLoginManager().logOut()
    }
}
