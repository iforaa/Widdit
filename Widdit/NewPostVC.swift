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

class NewPostVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var postTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var remainingLabel: UILabel!
    private var valueLabel: UILabel!
    private var progressLabel: UILabel!

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
        .BarColor(UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)),
        .ThumbColor(UIColor(red: 141/255, green: 185/255, blue: 204/255, alpha: 1)),
        .TrackingColor(UIColor(red: 78/255, green: 136/255, blue: 185/255, alpha: 1)),
        .BarWidth(20),
        .StartAngle(-45),
        .MaxValue(150),
        .MinValue(20)
      ]
    }

    private var progressOptions: [CircleSliderOption] {
      return [
        .BarColor(UIColor(red: 255/255, green: 190/255, blue: 190/255, alpha: 0.3)),
        .TrackingColor(UIColor(red: 159/255, green: 0/255, blue: 0/255, alpha: 1)),
        .BarWidth(30),
        .SliderEnabled(false)
      ]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable post button
        postBtn.enabled = false

        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        self.postTxt.delegate = self

        self.buildCircleSlider()

        //progress slider
//        let progress = KDCircularProgress(frame: CGRect(x: 100, y: 100, width: 300, height: 300))
//        progress.startAngle = -90
//        progress.progressThickness = 0.2
//        progress.trackThickness = 0.7
//        progress.clockwise = true
////        progress.center = view.center
//        progress.gradientRotateSpeed = 2
//        progress.roundedCorners = true
//        progress.glowMode = .Forward
//        progress.angle = 300
//        progress.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor())
//        view.addSubview(progress)
//      let slider = CircleSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 300), options: nil)
      

    }

    private func buildCircleSlider() {
      self.circleSlider = CircleSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 300), options: self.sliderOptions)
      self.circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
      self.circleSlider.center = view.center
      self.view.addSubview(self.circleSlider!)
      self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      self.valueLabel.textAlignment = .Center
      self.valueLabel.center = self.circleSlider.center
      self.view.addSubview(self.valueLabel)
    }

    func valueChange(sender: CircleSlider) {
      switch sender.tag {
      case 0:
        self.valueLabel.text = "\(Int(sender.value))"
      case 1:
        self.progressLabel.text = "\(Int(sender.value))%"
      default:
        break
      }
    }


    // User Taps TextView
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.postTxt = textView
        self.postTxt.text = ""
        
        return true
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
            
            if remainingChar >= 0 && remainingChar <= 139 {
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
        object["username"] = PFUser.currentUser()?.username
        object["ava"] = PFUser.currentUser()?.valueForKey("ava") as! PFFile
        object["postText"] = postTxt.text
        object["firstName"] = PFUser.currentUser()?.valueForKey("firstName") as! String

        let uuid = NSUUID().UUIDString
        object["uuid"] = "\(PFUser.currentUser()?.username) \(uuid)"
        
        // Save Information
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
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
