//
//  PostCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class WDTCellCardView: UIView {
    
    var shadowLayer:CAShapeLayer? = nil
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if self.shadowLayer == nil {
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.TopLeft, .TopRight],
                                        cornerRadii: CGSize(width: 4.0, height: 4.0))
            
            self.shadowLayer = CAShapeLayer()
            self.shadowLayer!.path = maskPath.CGPath
            self.shadowLayer!.fillColor = UIColor.WDTGrayBlueColor().CGColor
            
            self.shadowLayer!.shadowColor = UIColor.darkGrayColor().CGColor
            self.shadowLayer!.shadowPath = self.shadowLayer!.path
            self.shadowLayer!.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.shadowLayer!.shadowOpacity = 0.5
            self.shadowLayer!.shadowRadius = 2
            
            layer.insertSublayer(self.shadowLayer!, atIndex: 0)
        }
        
    }
}

import Kingfisher
import AFImageHelper

class PostCell: UITableViewCell {
    
    var avaImage: UIImageView = UIImageView()
    var postPhoto: UIImageView = UIImageView()
    
    var postText: UITextView = UITextView()
    var moreBtn: UIButton = UIButton(type: .Custom)
    var timeLbl: UILabel = UILabel()
    var firstNameLbl: UILabel = UILabel()
    var userNameBtn: UIButton = UIButton(type: .Custom)
    var cardView: WDTCellCardView = WDTCellCardView()
    
    var morePostsButton: UIButton = UIButton(type: .Custom)
    var distanceLbl: UILabel = UILabel()
    
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
        self.cardView.addSubview(self.moreBtn)

        self.cardView.addSubview(self.vertLineView)
        self.cardView.addSubview(self.distanceLbl)
        
        self.vertLineView.backgroundColor = UIColor.grayColor()
        self.vertLineView.alpha = 0.5
        
        
        self.postText.backgroundColor = UIColor.WDTGrayBlueColor()
        self.postText.textColor = UIColor.grayColor()
        self.postText.editable = false
        self.postText.scrollEnabled = false
        
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

//        if isHeightCalculated == false {

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
                make.bottom.equalTo(self.cardView).offset(-25).priority(750)
                
            })

                self.moreBtn.snp_makeConstraints { (make) in
                    make.top.equalTo(self.postText.snp_bottom).offset(2)
                    make.right.equalTo(self.cardView).offset(-10)
//                    make.bottom.equalTo(self.cardView).offset(-10).priority(750)
                }

        
//        }
//            isHeightCalculated = true

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
//        self.imDownBtn.hidden = false
        self.userNameBtn.hidden = false
        self.moreBtn.hidden = false
        
        if PFUser.currentUser()?.username == user.username {
//            self.replyBtn.hidden = true
//            self.imDownBtn.hidden = true
            self.myPost = true
        } else {
//            self.replyBtn.hidden = false
//            self.imDownBtn.hidden = false
            self.myPost = false
        }
        

        
        
        // Place Profile Picture
        let avaFile: PFFile = user["ava"] as! PFFile
        self.avaImage.kf_setImageWithURL(NSURL(string: avaFile.url!)!)
        
        if let photoFile = post["photoFile"]  {
            
            
            let pfFile: PFFile = photoFile as! PFFile
            let url = pfFile.url!
            self.postPhoto.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(color: UIColor.WDTBlueColor(), size: CGSizeMake(self.bounds.size.width, 200)), optionsInfo: nil, progressBlock: nil, completionHandler: nil)

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
            make.bottom.equalTo(self.contentView)
        }
        
        self.cardView.backgroundColor = UIColor.clearColor()
    }
    
    
    
    @IBAction func morePostsButtonPressed(sender: UIButton) {

    }
    

}
