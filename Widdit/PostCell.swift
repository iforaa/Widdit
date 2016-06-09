//
//  PostCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class WDTCardView: UIView {
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
        layer.cornerRadius = 4.0
    }
}

class PostCell2: UITableViewCell {
    
    var avaImage: UIImageView = UIImageView()
    var postPhoto: UIImageView = UIImageView()
    
    var postText: UITextView = UITextView()
    var imDownBtn: UIButton = UIButton(type: .Custom)
    var timeLbl: UILabel = UILabel()
    var firstNameLbl: UILabel = UILabel()
    var userNameBtn: UIButton = UIButton(type: .Custom)
    var cardView: WDTCardView = WDTCardView()
    var moreBtn: UIButton = UIButton(type: .Custom)
    var replyBtn: UIButton = UIButton(type: .Custom)
    var morePostsButton: UIButton = UIButton(type: .Custom)
    var distanceLbl: UILabel = UILabel()
    var horlLineView = UIView()
    var vertLineView = UIView()
    
    var user: PFUser!
    var post: PFObject!
    var myPost: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configureSubviews() {
        
        self.contentView.addSubview(self.cardView)

        self.cardView.addSubview(self.avaImage)
        self.cardView.addSubview(self.postPhoto)
        self.cardView.addSubview(self.postText)
        self.cardView.addSubview(self.timeLbl)
        self.cardView.addSubview(self.firstNameLbl)
        self.cardView.addSubview(self.userNameBtn)
        self.cardView.addSubview(self.imDownBtn)
        self.cardView.addSubview(self.replyBtn)
        self.cardView.addSubview(self.moreBtn)
        self.cardView.addSubview(self.horlLineView)
        self.cardView.addSubview(self.vertLineView)
        self.cardView.addSubview(self.distanceLbl)
        
        self.horlLineView.backgroundColor = UIColor.grayColor()
        self.horlLineView.alpha = 0.5
        self.vertLineView.backgroundColor = UIColor.grayColor()
        self.vertLineView.alpha = 0.5
        
        self.replyBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.replyBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.replyBtn.setTitle("Reply", forState: .Normal)
        self.replyBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        
        self.imDownBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.imDownBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.imDownBtn.addTarget(self, action: #selector(downBtnTapped), forControlEvents: .TouchUpInside)
        self.imDownBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        self.postText.backgroundColor = UIColor.WDTGrayBlueColor()
        self.postText.textColor = UIColor.grayColor()
        self.postText.editable = false
        
        // Rounded Square Image
        self.avaImage.layer.cornerRadius = 8.0
        self.avaImage.clipsToBounds = true
        
        self.userNameBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.userNameBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        self.userNameBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        self.userNameBtn.titleLabel?.textAlignment = .Left
        
        self.moreBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.moreBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        self.moreBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        self.moreBtn.setTitle("More posts...", forState: .Normal)
        
        
        self.firstNameLbl.textColor = UIColor.grayColor()
        self.firstNameLbl.font = UIFont.systemFontOfSize(12)
        
        self.timeLbl.textColor = UIColor.grayColor()
        self.timeLbl.font = UIFont.systemFontOfSize(12)
        
        self.distanceLbl.textColor = UIColor.grayColor()
        self.distanceLbl.font = UIFont.systemFontOfSize(12)
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.cardSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isHeightCalculated: Bool = false
    
    override func updateConstraints() {

       // if isHeightCalculated == false {

            self.avaImage.snp_remakeConstraints(closure: { (make) in
                make.top.equalTo(self.cardView).offset(10)
                make.left.equalTo(self.cardView).offset(10)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            
            self.userNameBtn.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self.avaImage.snp_right).offset(7)
                make.top.equalTo(self.cardView).offset(5)
            })
        
            self.firstNameLbl.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(self.avaImage.snp_right).offset(10)
                make.top.equalTo(self.userNameBtn.snp_bottom).offset(-4)
            })

            self.timeLbl.snp_remakeConstraints(closure: { (make) in
                make.right.equalTo(self.cardView).offset(-10)
                make.top.equalTo(self.cardView).offset(10)
            })
        
            self.distanceLbl.snp_remakeConstraints(closure: { (make) in
                make.right.equalTo(self.cardView).offset(-10)
                make.top.equalTo(self.timeLbl.snp_bottom).offset(5)
            })
        
            self.postPhoto.snp_remakeConstraints(closure: { (make) in
                make.top.equalTo(self.avaImage.snp_bottom).offset(10)
                make.left.equalTo(self.cardView).offset(10)
                make.right.equalTo(self.cardView).offset(-10)
                make.height.equalTo(self.postPhoto.snp_width).multipliedBy(0.625)
            })
            
            self.postText.snp_remakeConstraints(closure: { (make) in
                if let _ = self.postPhoto.image {
                    make.top.equalTo(self.postPhoto.snp_bottom).offset(10)
                } else {
                    make.top.equalTo(self.avaImage.snp_bottom).offset(10)
                }
                make.left.equalTo(self.cardView).offset(10)
                make.right.equalTo(self.cardView).offset(-10)
                make.height.equalTo(40)
                
            })

            if self.myPost == false {
                
                self.moreBtn.snp_makeConstraints { (make) in
                    make.top.equalTo(self.postText.snp_bottom).offset(2)
                    make.right.equalTo(self.cardView).offset(-10)
                }
                
                self.horlLineView.snp_makeConstraints { (make) in
                    make.top.equalTo(self.moreBtn.snp_bottom).offset(2)
                    make.width.equalTo(self.cardView).multipliedBy(0.9)
                    make.centerX.equalTo(self.cardView)
                    make.height.equalTo(1)
                }
                
                self.replyBtn.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.horlLineView.snp_bottom).offset(10)
                    make.left.equalTo(self.cardView).offset(10)
                    make.bottom.equalTo(self.cardView).offset(-10).priority(750)
                    make.right.equalTo(self.cardView.snp_centerX)
                }
                
                self.imDownBtn.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.horlLineView.snp_bottom).offset(10)
                    make.left.equalTo(self.cardView.snp_centerX)
                    make.bottom.equalTo(self.cardView).offset(-10).priority(750)
                    make.right.equalTo(self.cardView).offset(-10)
                }
            } else {
                self.moreBtn.snp_makeConstraints { (make) in
                    make.top.equalTo(self.postText.snp_bottom).offset(2)
                    make.right.equalTo(self.cardView).offset(-10)
                    make.bottom.equalTo(self.cardView).offset(-10).priority(750)
                }
            }
        
        

            isHeightCalculated = true
        //}
        super.updateConstraints()
    }

    
    

    
    func cardSetup() {
        self.cardView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        self.cardView.backgroundColor = UIColor.WDTGrayBlueColor()
    }
    
    
    
    @IBAction func morePostsButtonPressed(sender: UIButton) {

    }
    
    @IBAction func downBtnTapped(sender: AnyObject) {
        
        // declare title of button
        let title = sender.titleForState(.Normal)
       
        if title == "I'm Down" {
            sender.setTitle("Undown", forState: .Normal)
            let object = PFObject(className: "downs")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = self.user.username
            object["post"] = self.post
            object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Downed")
                    
                    // send notification as down
                    if self.user.username != PFUser.currentUser()?.username {
                        let activityObj = PFObject(className: "Activity")
                        activityObj["by"] = PFUser.currentUser()?.username
                        activityObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        activityObj["to"] = self.user.username
                        activityObj["owner"] = self.user.username
                        activityObj["type"] = "down"
                        activityObj["postText"] = self.postText.text
                        activityObj.saveEventually()
                    }
                }
            })
            
            // to unDown
        } else {
            sender.setTitle("I'm Down", forState: .Normal)
            // request existing downs of current user to show post
            let query = PFQuery(className: "downs")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: (user.username)!)
            query.whereKey("post", equalTo: self.post)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                // find objects - downs
                for object in objects! {
                    // delete found downs
                    object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            print("Undowned")
                            
                            // delete down notification
                            let activityQuery = PFQuery(className: "Activity")
                            activityQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            activityQuery.whereKey("to", equalTo: self.user.username!)
                            activityQuery.whereKey("uuid", equalTo: self.user.username!)
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

class PostCell: UICollectionViewCell {
    
    var avaImage: UIImageView = UIImageView()
    var postText: UITextView = UITextView()
    var imDownBtn: UIButton = UIButton(type: .Custom)
    var timeLbl: UILabel = UILabel()
    var firstNameLbl: UILabel = UILabel()
    var userNameBtn: UIButton = UIButton(type: .Custom)
    var uuidLbl: UILabel = UILabel()
    var cardView: UIView = UIView()
    var moreBtn: UIButton = UIButton(type: .Custom)
    var replyBtn: UIButton = UIButton(type: .Custom)
    var morePostsButton: UIButton = UIButton(type: .Custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.addSubview(self.cardView)
        
        
        
        self.cardView.addSubview(self.avaImage)
        
        self.avaImage.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(60)
        }
        
        self.cardView.addSubview(self.postText)
        
        self.postText.scrollEnabled = false
        self.postText.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
            make.top.equalTo(self.avaImage.snp_bottom).offset(5)
            make.height.equalTo(50)
        }
        
        
        self.cardView.addSubview(self.imDownBtn)
        
        self.imDownBtn.snp_makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.equalTo(self.contentView).offset(-5)
            make.right.equalTo(self.contentView.snp_centerX)
            make.bottom.equalTo(self.contentView)
        }
        
        self.cardView.addSubview(self.replyBtn)
        
        self.replyBtn.snp_makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.equalTo(self.contentView.snp_centerX).offset(5)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        
        
        self.cardView.snp_makeConstraints { (make) in
            make.height.equalTo(self.avaImage.snp_height)
            
        }
        
        self.imDownBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.postText.backgroundColor = UIColor.WDTGrayBlueColor()
        self.uuidLbl.hidden = true
        
        // Rounded Square Image
        self.avaImage.layer.cornerRadius = 8.0
        self.avaImage.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    var isHeightCalculated: Bool = false
    
    
    
    //    func cardSetup() {
    //        self.cardView.alpha = 1
    //        self.cardView.layer.masksToBounds = false
    //        self.cardView.layer.cornerRadius = 2
    //        self.cardView.layer.shadowOffset = CGSizeMake(0, 1)
    //        self.cardView.layer.shadowRadius = 5
    //        let path = UIBezierPath()
    ////        self.cardView.layer.shadowOpacity = 0.5
    ////        self.cardView.layer.shadowPath = path.CGPath
    //        self.cardView.backgroundColor = UIColor.WDTGrayBlueColor()
    //        self.backgroundColor = UIColor.WDTGrayBlueColor()
    //    }
    
    //    override func layoutSubviews() {
    //        self.cardSetup()
    //    }
    
    @IBAction func morePostsButtonPressed(sender: UIButton) {
        
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


