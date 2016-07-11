//
//  EditVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController
import ParseFacebookUtilsV4

enum WDTSituation: Int {
    case School
    case Working
    case Opportunity
    
    
    func getDescription() -> String {
        switch self {
        case .School:
            return "School"
        case .Working:
            return "Working"
        case .Opportunity:
            return "Opportunity"
        }
    }
    
}

class EditVC: UIViewController, UITextViewDelegate {

    var tableView: UITableView!

    // UI objects
    let scrollView = UIScrollView()
    
    var firstNameTxt: UITextField = UITextField()
    var usernameTxt: UITextField = UITextField()
    var emailTxt: UITextField = UITextField()
    var aboutTxt: WDTPlaceholderTextView = WDTPlaceholderTextView()
    let facebookLinkingBtn = UIButton(type: .Custom)
    let situationSgmtCtrl = UISegmentedControl(items: ["School", "Working", "Opportunity"])
    
    let addAvatar1 = UIButton()
    let addAvatar2 = UIButton()
    let addAvatar3 = UIButton()
    let addAvatar4 = UIButton()
    let deleteAvatar2 = UIButton()
    let deleteAvatar3 = UIButton()
    let deleteAvatar4 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneButtonTapped))
        
        scrollView.addSubview(addAvatar1)
        addAvatar1.layer.cornerRadius = 10
        addAvatar1.backgroundColor = UIColor.WDTGrayBlueColor()
        addAvatar1.tag = 1
        addAvatar1.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar1.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(scrollView).offset(50)
            make.width.equalTo(view.snp_width).multipliedBy(0.4)
            make.height.equalTo(view.snp_width).multipliedBy(0.4)
        }
        
        
        scrollView.addSubview(addAvatar2)
        addAvatar2.layer.cornerRadius = 10
        addAvatar2.backgroundColor = UIColor.WDTGrayBlueColor()
        addAvatar2.tag = 2
        addAvatar2.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar2.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(scrollView).offset(50)
            make.width.equalTo(view.snp_width).multipliedBy(0.4)
            make.height.equalTo(view.snp_width).multipliedBy(0.4)
        }
        
        addAvatar2.addSubview(deleteAvatar2)
        deleteAvatar2.hidden = true
        deleteAvatar2.tag = 2
        deleteAvatar2.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        deleteAvatar2.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        deleteAvatar2.snp_makeConstraints { (make) in
            make.right.equalTo(addAvatar2).offset(5)
            make.bottom.equalTo(addAvatar2).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        
        scrollView.addSubview(addAvatar3)
        addAvatar3.layer.cornerRadius = 10
        addAvatar3.backgroundColor = UIColor.WDTGrayBlueColor()
        addAvatar3.tag = 3
        addAvatar3.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar3.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(addAvatar1.snp_bottom).offset(30)
            make.width.equalTo(view.snp_width).multipliedBy(0.4)
            make.height.equalTo(view.snp_width).multipliedBy(0.4)
        }
        
        addAvatar3.addSubview(deleteAvatar3)
        deleteAvatar3.hidden = true
        deleteAvatar3.tag = 3
        deleteAvatar3.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        deleteAvatar3.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        deleteAvatar3.snp_makeConstraints { (make) in
            make.right.equalTo(addAvatar3).offset(5)
            make.bottom.equalTo(addAvatar3).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        scrollView.addSubview(addAvatar4)
        addAvatar4.layer.cornerRadius = 10
        addAvatar4.backgroundColor = UIColor.WDTGrayBlueColor()
        addAvatar4.tag = 4
        addAvatar4.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar4.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(addAvatar2.snp_bottom).offset(30)
            make.width.equalTo(view.snp_width).multipliedBy(0.4)
            make.height.equalTo(view.snp_width).multipliedBy(0.4)
        }
        
        addAvatar4.addSubview(deleteAvatar4)
        deleteAvatar4.hidden = true
        deleteAvatar4.tag = 4
        deleteAvatar4.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        deleteAvatar4.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        deleteAvatar4.snp_makeConstraints { (make) in
            make.right.equalTo(addAvatar4).offset(5)
            make.bottom.equalTo(addAvatar4).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        firstNameTxt.placeholder = "Enter Name"
        firstNameTxt.font = UIFont.WDTAgoraRegular(16)
        scrollView.addSubview(firstNameTxt)
        firstNameTxt.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(addAvatar4.snp_bottom).offset(20)
        }
        
        usernameTxt.placeholder = "Enter Username"
        usernameTxt.font = UIFont.WDTAgoraRegular(16)
        scrollView.addSubview(usernameTxt)
        usernameTxt.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(firstNameTxt.snp_bottom).offset(20)
        }
        
        emailTxt.placeholder = "Enter Email"
        emailTxt.font = UIFont.WDTAgoraRegular(16)
        scrollView.addSubview(emailTxt)
        emailTxt.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(usernameTxt.snp_bottom).offset(20)
        }
        

        scrollView.addSubview(aboutTxt)
        aboutTxt.placeholder = "Enter About Text"
        aboutTxt.delegate = self
        aboutTxt.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(emailTxt.snp_bottom).offset(20)
            make.height.equalTo(80)
        }
        
        
        
        facebookLinkingBtn.backgroundColor = UIColor.WDTBlueColor()
        facebookLinkingBtn.addTarget(self, action: #selector(facebookLinkingBtnTapped), forControlEvents: .TouchUpInside)
        facebookLinkingBtn.layer.cornerRadius = 4
        facebookLinkingBtn.clipsToBounds = true
        scrollView.addSubview(facebookLinkingBtn)
        if PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) == true {
            facebookLinkingBtn.setTitle("Unlink Facebook", forState: .Normal)
        } else {
            facebookLinkingBtn.setTitle("Link Facebook", forState: .Normal)
        }
        
        facebookLinkingBtn.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(aboutTxt.snp_bottom).offset(20)
            make.height.equalTo(40)
        }
        
        
        
        scrollView.addSubview(situationSgmtCtrl)
        situationSgmtCtrl.tintColor = UIColor.WDTBlueColor()
        situationSgmtCtrl.addTarget(self, action: #selector(situationSgmtCtrlTapped), forControlEvents: .ValueChanged)
        situationSgmtCtrl.snp_makeConstraints { (make) in
            make.top.equalTo(facebookLinkingBtn.snp_bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        
        
        let vvv = UIView()
        scrollView.addSubview(vvv)
        vvv.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(situationSgmtCtrl.snp_bottom)
            make.bottom.equalTo(scrollView).offset(-30).priority(751)
        }
        
        
        information()

    }
    
    
    func information() {
        
        WDTAvatar.getAvatar(PFUser.currentUser()!, avaNum: 1) { (ava) in
            if let ava = ava {
                //                self.deleteAvatar1.hidden = false
                self.addAvatar1.setImage(ava, forState: .Normal)
            }
            
        }
        
        WDTAvatar.getAvatar(PFUser.currentUser()!, avaNum: 2) { (ava) in
            if let ava = ava {
                self.deleteAvatar2.hidden = false
                self.addAvatar2.setImage(ava, forState: .Normal)
            }
            
        }
        
        WDTAvatar.getAvatar(PFUser.currentUser()!, avaNum: 3) { (ava) in
            if let ava = ava {
                self.deleteAvatar3.hidden = false
                self.addAvatar3.setImage(ava, forState: .Normal)
            }
            
        }
        
        WDTAvatar.getAvatar(PFUser.currentUser()!, avaNum: 4) { (ava) in
            if let ava = ava {
                self.deleteAvatar4.hidden = false
                self.addAvatar4.setImage(ava, forState: .Normal)
            }
            
        }
        
        // receive text information
        usernameTxt.text = PFUser.currentUser()?.username
        firstNameTxt.text = PFUser.currentUser()?.objectForKey("firstName") as? String
        aboutTxt.text = PFUser.currentUser()?.objectForKey("about") as? String
        emailTxt.text = PFUser.currentUser()?.objectForKey("email") as? String
        
        
        let situationInt = PFUser.currentUser()?.objectForKey("situation") as? Int
        if let situationInt = situationInt {
            situationSgmtCtrl.selectedSegmentIndex = situationInt
        }
        
    }
    
    
    func situationSgmtCtrlTapped() {
        
    }
    
    func facebookLinkingBtnTapped() {
        let user = PFUser.currentUser()!
        
        if PFFacebookUtils.isLinkedWithUser(user) == true {
            user["facebookVerified"] = false
            user.saveInBackground()
            PFFacebookUtils.unlinkUserInBackground(user, block: { (succeeded: Bool?, error: NSError?) in
                if let _ = succeeded {
                    self.facebookLinkingBtn.setTitle("Link Facebook", forState: .Normal)
                }
            })
            
        } else {
            facebookLinkingBtn.setTitle("Link Facebook", forState: .Normal)
            user["facebookVerified"] = true
            user.saveInBackground()
            PFFacebookUtils.linkUserInBackground(user, withReadPermissions: nil, block: {
                (succeeded: Bool?, error: NSError?) -> Void in
                if let _ = succeeded {
                    self.facebookLinkingBtn.setTitle("Unlink Facebook", forState: .Normal)
                }
            })
        }
    }
    
    
    func addAvatarButtonTapped(sender: AnyObject) {
        
        let cameraViewController = CameraViewController(croppingEnabled: true) { image in
            if let image = image.0 {
                var resizedImage: UIImage!
                let user = PFUser.currentUser()!
                
                resizedImage = UIImage.resizeImage(image, newWidth: 400)
                resizedImage = resizedImage.roundCorners(20)
                let avaData = UIImageJPEGRepresentation(resizedImage, 0.5)
                let avaFile = PFFile(name: "ava.jpg", data: avaData!)
                
                if sender.tag == 1 {
                    self.addAvatar1.setImage(resizedImage, forState: .Normal)
                    user["ava"] = avaFile
                    
                } else if sender.tag == 2 {
                    self.addAvatar2.setImage(resizedImage, forState: .Normal)
                    user["ava2"] = avaFile
                    self.deleteAvatar2.hidden = false
                    
                } else if sender.tag == 3 {
                    self.addAvatar3.setImage(resizedImage, forState: .Normal)
                    user["ava3"] = avaFile
                    self.deleteAvatar3.hidden = false
                    
                } else if sender.tag == 4 {
                    self.addAvatar4.setImage(resizedImage, forState: .Normal)
                    user["ava4"] = avaFile
                    self.deleteAvatar4.hidden = false
                }
                
                user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) -> Void in
                    if success {
                        
                    }
                })
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    
    func deletePhotoButtonTapped(sender: AnyObject) {
        let user = PFUser.currentUser()!
        if sender.tag! == 1 {
            self.addAvatar1.setImage(nil, forState: .Normal)
            //            self.deleteAvatar1.hidden = true
            user.removeObjectForKey("ava")
            
        } else if sender.tag! == 2 {
            self.addAvatar2.setImage(nil, forState: .Normal)
            self.deleteAvatar2.hidden = true
            user.removeObjectForKey("ava2")
            
        } else if sender.tag! == 3 {
            self.addAvatar3.setImage(nil, forState: .Normal)
            self.deleteAvatar3.hidden = true
            user.removeObjectForKey("ava3")
            
        } else if sender.tag! == 4 {
            self.addAvatar4.setImage(nil, forState: .Normal)
            self.deleteAvatar4.hidden = true
            user.removeObjectForKey("ava4")
        }
        
        
        
        
        user.saveInBackground()
        
    }
    
    
    func doneButtonTapped() {

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
        user["about"] = aboutTxt.text
        user["situation"] = situationSgmtCtrl.selectedSegmentIndex
        
        // if "gender" is empty, send empty data, else entered data
        //        if genderTxt.text!.isEmpty {
        //            user["gender"] = ""
        //        } else {
        //            user["gender"] = genderTxt.text
        //        }
        
        
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
    
    // regex restrictions for email textfield
    func validateEmail (email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func textView(textView: UITextView,
                  shouldChangeTextInRange range: NSRange,
                                          replacementText text: String) -> Bool{
        
        let currentLength:Int = (textView.text as NSString).length
        let newLength:Int = (textView.text as NSString).length + (text as NSString).length - (range.length)
//        let remainingChar:Int = 140 - currentLength
        
        aboutTxt.textColor = UIColor .blackColor()
        if text != "" {
            return (newLength > 140) ? false : true
        } else {
            return true
        }
        
    }



}