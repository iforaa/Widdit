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

class PostCell: UITableViewCell {
    
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
    var geoPoint: PFGeoPoint?
    
    var user: PFUser!
    var post: PFObject!
    var myPost: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        self.selectionStyle = .None
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
        self.replyBtn.titleLabel?.font = UIFont.WDTAgoraRegular(14)
        
        
        self.imDownBtn.backgroundColor = UIColor.WDTGrayBlueColor()
        self.imDownBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.imDownBtn.addTarget(self, action: #selector(downBtnTapped), forControlEvents: .TouchUpInside)
        self.imDownBtn.titleLabel?.font = UIFont.WDTAgoraRegular(14)
        
        self.postText.backgroundColor = UIColor.WDTGrayBlueColor()
        self.postText.textColor = UIColor.grayColor()
        self.postText.editable = false
        
        // Rounded Square Image
        self.avaImage.layer.cornerRadius = 8.0
        self.avaImage.clipsToBounds = true
        
        self.userNameBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.userNameBtn.titleLabel?.font = UIFont.WDTAgoraRegular(12)
        self.userNameBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        self.userNameBtn.titleLabel?.textAlignment = .Left
        
        self.moreBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.moreBtn.titleLabel?.font = UIFont.WDTAgoraRegular(12)
        self.moreBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        self.moreBtn.setTitle("More posts...", forState: .Normal)
        
        
        self.firstNameLbl.textColor = UIColor.grayColor()
        self.firstNameLbl.font = UIFont.WDTAgoraRegular(12)
        
        self.timeLbl.textColor = UIColor.grayColor()
        self.timeLbl.font = UIFont.WDTAgoraRegular(12)
        
        self.distanceLbl.textColor = UIColor.grayColor()
        self.distanceLbl.font = UIFont.WDTAgoraRegular(12)
        
        
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

    
    
    func fillCell(post: PFObject) {
        let user = post["user"] as! PFUser
        
        let username = user.username
        self.userNameBtn.setTitle(username, forState: .Normal)
        self.post = post
        self.user = user
    
        
        self.postText.text = post["postText"] as! String
        self.firstNameLbl.text = user["firstName"] as? String
        self.imDownBtn.hidden = false
        self.userNameBtn.hidden = false
        self.moreBtn.hidden = false
        
        if PFUser.currentUser()?.username == user.username {
            self.replyBtn.hidden = true
            self.imDownBtn.hidden = true
            self.myPost = true
        } else {
            self.replyBtn.hidden = false
            self.imDownBtn.hidden = false
            self.myPost = false
        }
        
        WDTActivity.isDown(user, post: post) { (down) in
            if down == true {
                self.imDownBtn.setTitle("I'm Down", forState: .Normal)
            } else {
                self.imDownBtn.setTitle("Undown", forState: .Normal)
            }
        }
        
        
        // Place Profile Picture
        user["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            self.avaImage.image = UIImage(data: data!)
        }
        
        
        if let photoFile = post["photoFile"] {
            self.postPhoto.image = UIImage()
            
            photoFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                self.postPhoto.image = UIImage(data: data!)
            }
        } else {
            self.postPhoto.image = nil
        }
        
        let hoursexpired = post["hoursexpired"] as! NSDate
        let timeLeft = hoursexpired.timeIntervalSince1970 - NSDate().timeIntervalSince1970
        
        self.timeLbl.text = NSDateComponentsFormatter.wdtLeftTime(Int(timeLeft)) + " left"
        
        if let postGeoPoint = post["geoPoint"] {
            self.distanceLbl.text = String(format: "%.1f mi", postGeoPoint.distanceInMilesTo(self.geoPoint))
        } else {
            self.distanceLbl.text = ""
        }
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
            print("Downed")
            sender.setTitle("Undown", forState: .Normal)
            WDTActivity.addActivity(self.user, post: self.post, type: .Down)
            
        } else {
            print("UnDown")
            sender.setTitle("I'm Down", forState: .Normal)
            WDTActivity.deleteActivity(self.user, type: .Down)
        }
    }
}
