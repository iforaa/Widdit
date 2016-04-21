//
//  PostCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var imDownBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet var replyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        imDownBtn.backgroundColor = UIColor .whiteColor()
        
        uuidLbl.hidden = true
    
        
        
        // Rounded Square Image
        avaImage.layer.cornerRadius = 8.0
        avaImage.clipsToBounds = true
        
        }
    
    func cardSetup() {
        self.cardView.alpha = 1
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 1
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.cardView.layer.shadowRadius = 1
        let path = UIBezierPath()
        self.cardView.layer.shadowOpacity = 0.2
        self.cardView.layer.shadowPath = path.CGPath
 
    }
    
    override func layoutSubviews() {
        self.cardSetup()
    }
    
    @IBAction func downBtnTapped(sender: AnyObject) {
        
        // declare title of button
        let title = sender.titleForState(.Normal)
       
        if title == "I'm Down" {
            
            let object = PFObject(className: "downs")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Downed")
                    
                    // send notification if we downed to refresh collectionView
                    NSNotificationCenter.defaultCenter().postNotificationName("downed", object: nil)
                    
                    // send notification as down
                    if self.userNameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let activityObj = PFObject(className: "Activity")
                        activityObj["by"] = PFUser.currentUser()?.username
                        activityObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        activityObj["to"] = self.userNameBtn.titleLabel?.text
                        activityObj["owner"] = self.userNameBtn.titleLabel?.text
                        activityObj["uuid"] = self.uuidLbl.text
                        activityObj["type"] = "down"
                        activityObj["postText"] = self.postText.text
                        activityObj.saveEventually()
                    }
                    
                    
                }
            })
            
            // to unDown
        } else {
            
            // request existing downs of current user to show post
            let query = PFQuery(className: "downs")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                // find objects - downs
                for object in objects! {
                    // delete found downs
                    object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            print("Undowned")
                          
                            
                            // send notification if we downed to refreash CollectionView
                            NSNotificationCenter.defaultCenter().postNotificationName("downed", object: nil)
                            
                            // delete down notification
                            let activityQuery = PFQuery(className: "Activity")
                            activityQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            activityQuery.whereKey("to", equalTo: self.userNameBtn.titleLabel!.text!)
                            activityQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            activityQuery.whereKey("type", equalTo: "down")
                            activityQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                        }
                    })
                }
            })
            
        }
    }
    
}


