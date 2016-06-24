//
//  EditVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ImagePicker

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerDelegate {
    
    
    // UI objects
    
    var avaImg: UIImageView!
    
    var firstNameTxt: UITextField!
    var usernameTxt: UITextField!
    var bioTxt: UITextView!
    
    var emailTxt: UITextField!
    var genderTxt: UITextField!
    // pickerView & pickerData
    var genderPicker : UIPickerView!
    let genders = ["male","female"]
    
    let imagePickerController = ImagePickerController()
    
    let addAvatar1 = UIButton()
    let addAvatar2 = UIButton()
    let addAvatar3 = UIButton()
    let addAvatar4 = UIButton()
//    let deleteAvatar1 = UIButton()
    let deleteAvatar2 = UIButton()
    let deleteAvatar3 = UIButton()
    let deleteAvatar4 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneButtonTapped))
        
        
        
        self.view.addSubview(self.addAvatar1)
        self.addAvatar1.layer.cornerRadius = 10
        self.addAvatar1.backgroundColor = UIColor.WDTGrayBlueColor()
        self.addAvatar1.tag = 1
        self.addAvatar1.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        self.addAvatar1.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(80)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.4)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.4)
        }
        
//        self.addAvatar1.addSubview(self.deleteAvatar1)
//        self.deleteAvatar1.hidden = true
//        self.deleteAvatar1.tag = 1
//        self.deleteAvatar1.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
//        self.deleteAvatar1.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
//        self.deleteAvatar1.snp_makeConstraints { (make) in
//            make.right.equalTo(self.addAvatar1).offset(5)
//            make.bottom.equalTo(self.addAvatar1).offset(5)
//            make.width.equalTo(18)
//            make.height.equalTo(18)
//        }
        
        
        self.view.addSubview(self.addAvatar2)
        self.addAvatar2.layer.cornerRadius = 10
        self.addAvatar2.backgroundColor = UIColor.WDTGrayBlueColor()
        self.addAvatar2.tag = 2
        self.addAvatar2.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        self.addAvatar2.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(80)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.4)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.4)
        }
        
        self.addAvatar2.addSubview(self.deleteAvatar2)
        self.deleteAvatar2.hidden = true
        self.deleteAvatar2.tag = 2
        self.deleteAvatar2.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        self.deleteAvatar2.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        self.deleteAvatar2.snp_makeConstraints { (make) in
            make.right.equalTo(self.addAvatar2).offset(5)
            make.bottom.equalTo(self.addAvatar2).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        
        self.view.addSubview(addAvatar3)
        self.addAvatar3.layer.cornerRadius = 10
        self.addAvatar3.backgroundColor = UIColor.WDTGrayBlueColor()
        self.addAvatar3.tag = 3
        addAvatar3.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar3.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(addAvatar1.snp_bottom).offset(30)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.4)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.4)
        }
        
        self.addAvatar3.addSubview(self.deleteAvatar3)
        self.deleteAvatar3.hidden = true
        self.deleteAvatar3.tag = 3
        self.deleteAvatar3.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        self.deleteAvatar3.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        self.deleteAvatar3.snp_makeConstraints { (make) in
            make.right.equalTo(self.addAvatar3).offset(5)
            make.bottom.equalTo(self.addAvatar3).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        self.view.addSubview(addAvatar4)
        self.addAvatar4.layer.cornerRadius = 10
        self.addAvatar4.backgroundColor = UIColor.WDTGrayBlueColor()
        self.addAvatar4.tag = 4
        addAvatar4.addTarget(self, action: #selector(addAvatarButtonTapped), forControlEvents: .TouchUpInside)
        addAvatar4.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(addAvatar2.snp_bottom).offset(30)
            make.width.equalTo(self.view.snp_width).multipliedBy(0.4)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.4)
        }
        
        self.addAvatar4.addSubview(self.deleteAvatar4)
        self.deleteAvatar4.hidden = true
        self.deleteAvatar4.tag = 4
        self.deleteAvatar4.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        self.deleteAvatar4.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        self.deleteAvatar4.snp_makeConstraints { (make) in
            make.right.equalTo(self.addAvatar4).offset(5)
            make.bottom.equalTo(self.addAvatar4).offset(5)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
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
//            // create picker
//            genderPicker = UIPickerView()
//            genderPicker.dataSource = self
//            genderPicker.delegate = self
//            genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
//            genderPicker.showsSelectionIndicator = true
//            genderTxt.inputView = genderPicker

        }
    
    func addAvatarButtonTapped(sender: AnyObject) {
        
        self.imagePickerController.delegate = self
        self.imagePickerController.imageLimit = 1
        self.imagePickerController.view.tag = sender.tag!
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
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
    
    // MARK: UIImagePickerControllerDelegate
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress() {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        var resizedImage: UIImage!
        
        
        let user = PFUser.currentUser()!
        
        for img in images {
            resizedImage = UIImage.resizeImage(img, newWidth: 400)
            resizedImage = resizedImage.roundCorners(20)
            let avaData = UIImageJPEGRepresentation(resizedImage, 0.5)
            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
            
            if self.imagePickerController.view.tag == 1 {
                self.addAvatar1.setImage(resizedImage, forState: .Normal)
                user["ava"] = avaFile
//                self.deleteAvatar1.hidden = false
                
                
            } else if self.imagePickerController.view.tag == 2 {
                self.addAvatar2.setImage(resizedImage, forState: .Normal)
                user["ava2"] = avaFile
                self.deleteAvatar2.hidden = false
                
            } else if self.imagePickerController.view.tag == 3 {
                self.addAvatar3.setImage(resizedImage, forState: .Normal)
                user["ava3"] = avaFile
                self.deleteAvatar3.hidden = false
                
            } else if self.imagePickerController.view.tag == 4 {
                self.addAvatar4.setImage(resizedImage, forState: .Normal)
                user["ava4"] = avaFile
                self.deleteAvatar4.hidden = false
            }
        }
        
        
        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) -> Void in
            if success {
                
            }
        })
        
//        self.deletePhotoButton.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func doneButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
    // func to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
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