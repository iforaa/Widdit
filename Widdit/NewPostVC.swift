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
    @IBOutlet var postDurationLabel: UILabel!
    @IBOutlet var sliderView: UIView!
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
        //default bar color: UIColor(red: 198/255, green: 244/255, blue: 23/255, alpha: 0.2)
        .BarColor(UIColor.blueColor()),
        .ThumbColor(UIColor.whiteColor()),
        .ThumbWidth(CGFloat(30)),
        .TrackingColor(UIColor.blueColor()),
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
      self.circleSlider = CircleSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 200), options: self.sliderOptions)
      self.circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
      self.sliderView.addSubview(self.circleSlider!)
      self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      self.valueLabel.textAlignment = .Center
      self.valueLabel.center = CGPoint(x: CGRectGetWidth(self.circleSlider.bounds) * 0.5, y: CGRectGetHeight(self.circleSlider.bounds) * 0.5)
      self.circleSlider.addSubview(self.valueLabel)
    }

    func valueChange(sender: CircleSlider) {
      switch sender.tag {
      case 0:
        self.valueLabel.text = "\(Int(sender.value))"
        self.postDurationLabel.text = "Post will be visible for \(Int(sender.value)) hours"
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
            
            if remainingChar >= 0 && remainingChar <= 139 && self.valueLabel.text != nil {
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

        func toLocalTime(date: NSDate) -> NSDate {
          let tz = NSTimeZone.localTimeZone()
          let seconds = tz.secondsFromGMTForDate(date)
          return NSDate(timeInterval: NSTimeInterval(seconds), sinceDate: date)
        }


        if let valueText = self.valueLabel.text {
          let today = NSDate()
          let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: Int(valueText)!, toDate: toLocalTime(today), options: NSCalendarOptions(rawValue: 0))
          print(tomorrow!)
          object["hoursexpired"] = tomorrow
        }

        let uuid = NSUUID().UUIDString
        object["uuid"] = "\(PFUser.currentUser()?.username) \(uuid)"

        let user = PFUser.currentUser()

        user!["posts"] = object

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
