//
//  NewPostVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

import ImagePicker
import MBProgressHUD
import CircleSlider




class NewPostVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var deletePhotoButton: UIButton = UIButton()
    var addPhotoButton: UIButton = UIButton()
    var postTxt: WDTPlaceholderTextView = WDTPlaceholderTextView()
    var remainingLabel: UILabel = UILabel()
    var postDurationLabel: UILabel = UILabel()
    var sliderView: UIView = UIView()
    var wdtSlider = WDTCircleSlider()
    
    var photoImage: UIImage?
    var geoPoint: PFGeoPoint?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable post button
        postBtn.enabled = false

        self.view.backgroundColor = UIColor.WDTGrayBlueColor()
        
        self.view.addSubview(self.postDurationLabel)
        self.view.addSubview(self.postTxt)
        self.view.addSubview(self.addPhotoButton)
        self.view.addSubview(self.remainingLabel)
        self.view.addSubview(self.postDurationLabel)
        self.view.addSubview(self.sliderView)
        self.view.addSubview(self.deletePhotoButton)
        
        self.postTxt.font = UIFont.WDTAgoraRegular(18)
        self.postTxt.placeholder = "What do you feel like doing"
        self.postTxt.backgroundColor = UIColor.WDTGrayBlueColor()
        self.postTxt.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(5)
            make.left.equalTo(self.view).offset(5)
            make.right.equalTo(self.view).offset(-5)
            make.height.equalTo(150)
        }
        self.addPhotoButton.setImage(UIImage(named: "AddPhotoButton"), forState: .Normal)
        self.addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), forControlEvents: .TouchUpInside)
        self.addPhotoButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.postTxt.snp_bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.deletePhotoButton.hidden = true
        self.deletePhotoButton.setImage(UIImage(named: "DeletePhotoButton"), forState: .Normal)
        self.deletePhotoButton.addTarget(self, action: #selector(deletePhotoButtonTapped), forControlEvents: .TouchUpInside)
        self.deletePhotoButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-11)
            make.top.equalTo(self.postTxt.snp_bottom).offset(11)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        let line = UIView()
        line.alpha = 0.6
        self.view.addSubview(line)
        line.backgroundColor = UIColor.grayColor()
        line.snp_makeConstraints { (make) in
            make.top.equalTo(self.addPhotoButton.snp_bottom).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.height.equalTo(1)
        }

        
        self.sliderView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-50)
            make.centerX.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        
        self.postDurationLabel.font = UIFont.WDTAgoraRegular(16)
        self.postDurationLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.sliderView.snp_top).offset(-25)
            make.centerX.equalTo(self.view)
        }
        
        self.postDurationLabel.text = "Use dial to set post expiration"
        
        
        

        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(NewPostVC.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        self.postTxt.delegate = self
        self.buildCircleSlider()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.geoPoint = geoPoint
            }
        }
    }

    func buildCircleSlider() {
        self.wdtSlider.addTarget(self, action: #selector(NewPostVC.valueChange(_:)), forControlEvents: .ValueChanged)
        self.sliderView.addSubview(self.wdtSlider)
        self.wdtSlider.snp_makeConstraints { (make) in
            make.edges.equalTo(self.sliderView)
        }

        
    }
    
    func valueChange(sender: CircleSlider) {
        self.wdtSlider.roundControll()
        
        var s = ""
        if Int(sender.value) == 1 {
            s = ""
        } else {
            s = "s"
        }
        
        if self.wdtSlider.circle == .Hours {
            self.postDurationLabel.text = "Lasts for \(Int(sender.value)) hour" + s
        } else {
            self.postDurationLabel.text = "Lasts for \(Int(sender.value)) day" + s
        }
        
        self.postGuard()
    }
    
    func addPhotoButtonTapped(sender: AnyObject) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func deletePhotoButtonTapped(sender: AnyObject) {
        self.deletePhotoButton.hidden = true
        self.addPhotoButton.setImage(UIImage(named: "AddPhotoButton"), forState: .Normal)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress() {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        for img in images {
            let resizedImage = UIImage.resizeImage(img, newWidth: 1080)
            self.addPhotoButton.setImage(resizedImage, forState: .Normal)
            self.photoImage = resizedImage
        }
        self.deletePhotoButton.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Text Changing in TextView
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
        
            let currentLength:Int = (textView.text as NSString).length
            let newLength:Int = (textView.text as NSString).length + (text as NSString).length - (range.length)
            let remainingChar:Int = 140 - currentLength
        
            self.postTxt.textColor = UIColor .blackColor()
            remainingLabel.text = "\(remainingChar)"
            self.postGuard()
            return (newLength > 140) ? false : true
    }
    
    func postGuard() {
        print(self.wdtSlider.value)
        if self.postTxt.text.characters.count > 0 && self.wdtSlider.value > 1 {
            self.postBtn.enabled = true
        } else {
            self.postBtn.enabled = false
        }
    }

    // hide keyboard function
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    // Cancel button tapped
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postBtnTapped(sender: AnyObject) {
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // send data to server to "posts" class in Parse
        let object = PFObject(className: "posts")
        object["postText"] = postTxt.text
        object["user"] = PFUser.currentUser()!

        if let geoPoint = self.geoPoint {
            object["geoPoint"] = geoPoint
        }
        
        var calendarUnit: NSCalendarUnit!
        if self.wdtSlider.circle == .Hours {
            calendarUnit = .Hour
        } else {
            calendarUnit = .Day
        }

        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(calendarUnit, value: Int(self.wdtSlider.value), toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        print(tomorrow!)
        object["hoursexpired"] = tomorrow
    

        let uuid = NSUUID().UUIDString
        object["uuid"] = "\(PFUser.currentUser()?.username) \(uuid)"

        if let image = self.photoImage {
            let photoData = UIImageJPEGRepresentation(image, 0.5)
            let photoFile = PFFile(name: "postPhoto.jpg", data: photoData!)
            
            
            object["photoFile"] = photoFile
            
            object["photoHeight"] = image.size.height
            object["photoWidth"] = image.size.width
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // Save Information
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if error == nil {
                // send notification with name "uploaded"
                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
                // dismiss editVC
                self.dismissViewControllerAnimated(true, completion: nil)
                // Reset Everything
                self.viewDidLoad()

            }
        }
    }
}
