//
//  NewPostVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import CircleSlider
import ImagePicker
import MBProgressHUD

class NewPostVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, ImagePickerDelegate {
    
    
    @IBOutlet weak var deletePhotoButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var postTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet var postDurationLabel: UILabel!
    var sliderView: UIView = UIView()
    private var progressLabel: UILabel!
    var sliderValue: Int?
    var photoImage: UIImage?
    var geoPoint: PFGeoPoint?
    
    private var circleProgress: CircleSlider! {
      didSet {
        self.circleProgress.tag = 1
      }
    }

    private var circleSlider: CircleSlider! {
      didSet {
        self.circleSlider.tag = 0
      }
    }

    private var sliderOptions: [CircleSliderOption] {
      return [
        //default bar color: UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)
        .BarColor(UIColor.grayColor()),
        .ThumbColor(UIColor.WDTGrayBlueColor()),
        .ThumbWidth(CGFloat(30)),
        .TrackingColor(UIColor.WDTBlueColor()),
        .BarWidth(5),
        .StartAngle(270),
        .MaxValue(24),
        .MinValue(0)
      ]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable post button
        postBtn.enabled = false


        self.postDurationLabel.text = "Use dial to set post expiration"

        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap")
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

    private func buildCircleSlider() {
        
        self.view.addSubview(self.sliderView)
        self.sliderView.snp_makeConstraints { (make) in
            make.top.equalTo(self.postDurationLabel.snp_bottom).offset(5)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.7)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.7)
        }
        
        self.circleSlider = CircleSlider(frame: CGRectZero, options: self.sliderOptions)
        self.circleSlider?.addTarget(self, action: #selector(NewPostVC.valueChange(_:)), forControlEvents: .ValueChanged)
        self.sliderView.addSubview(self.circleSlider!)
      
        
        
        
        self.circleSlider.snp_makeConstraints { (make) in
            make.edges.equalTo(self.sliderView)
        }
      
    }

    func valueChange(sender: CircleSlider) {
        self.sliderValue = Int(sender.value)
        self.postDurationLabel.text = "Post will be visible for \(Int(sender.value)) hours"
    }
    

    // User Taps TextView
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.postTxt = textView
        self.postTxt.text = ""
        
        return true
    }
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func deletePhotoButtonTapped(sender: AnyObject) {
        self.deletePhotoButton.alpha = 0.0
        self.addPhotoButton.setImage(UIImage(named: "AddPhotoButton"), forState: .Normal)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        for img in images {
            let resizedImage = UIImage.resizeImage(img, newWidth: 1080)
            self.addPhotoButton.setImage(resizedImage, forState: .Normal)
            self.photoImage = resizedImage
        }
        self.deletePhotoButton.alpha = 1.0
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonDidPress() {
        
    }
    
    
    // Text Changing in TextView
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            self.postTxt = textView
            
            let currentLength:Int = (textView.text as NSString).length
            let newLength:Int = (textView.text as NSString).length + (text as NSString).length - (range.length)
            let remainingChar:Int = 140 - currentLength
            
            
            self.postTxt.textColor = UIColor .blackColor()
            
            remainingLabel.text = "\(remainingChar)"
            
            if remainingChar >= 0 && remainingChar <= 139 && self.sliderValue != nil {
                self.postBtn.enabled = true
            } else {
                self.postBtn.enabled = false
            }
        
            return (newLength > 140) ? false : true
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
        
        
        if let sliderValue = self.sliderValue {
            let today = NSDate()
            let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: sliderValue, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            print(tomorrow!)
            object["hoursexpired"] = tomorrow
        }

        let uuid = NSUUID().UUIDString
        object["uuid"] = "\(PFUser.currentUser()?.username) \(uuid)"

        if let image = self.photoImage {
            let photoData = UIImagePNGRepresentation(image)
            let photoFile = PFFile(name:"postPhoto.png", data:photoData!)
            
            object["photoFile"] = photoFile
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
