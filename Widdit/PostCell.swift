//
//  PostCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class WDTCAShapeLayer: CAShapeLayer {
    var tag: Int?
}

class WDTCellCardView: UIView {
    
    var shadowLayer:WDTCAShapeLayer? = nil
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        
        if self.shadowLayer == nil {
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: [.TopLeft, .TopRight],
                                        cornerRadii: CGSize(width: 4.0, height: 4.0))
            
            self.shadowLayer = WDTCAShapeLayer()
            self.shadowLayer!.tag = 1
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
    
    func updateLayer() {
        layer.sublayers?.forEach {
            if let layer = $0 as? WDTCAShapeLayer {
                if layer.tag == 1 {
                    layer.removeFromSuperlayer()
                    self.shadowLayer = nil
                }
            }
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
        selectionStyle = .None
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configureSubviews() {
        backgroundColor = UIColor.whiteColor()
        cardView.backgroundColor = UIColor.clearColor()
        
        self.contentView.addSubview(cardView)

        cardView.addSubview(avaImage)
        cardView.addSubview(postPhoto)
        cardView.addSubview(postText)
        cardView.addSubview(timeLbl)
        cardView.addSubview(firstNameLbl)
        cardView.addSubview(userNameBtn)
        cardView.addSubview(moreBtn)

        cardView.addSubview(vertLineView)
        cardView.addSubview(distanceLbl)
        
        vertLineView.backgroundColor = UIColor.grayColor()
        vertLineView.alpha = 0.5
        
        
        postText.backgroundColor = UIColor.WDTGrayBlueColor()
        postText.textColor = UIColor.grayColor()
        postText.editable = false
        postText.scrollEnabled = false
        postText.userInteractionEnabled = true;
        postText.dataDetectorTypes = [.Link, .PhoneNumber]
        
        
        // Rounded Square Image
        avaImage.layer.cornerRadius = 8.0
        avaImage.clipsToBounds = true
        
        
        userNameBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        userNameBtn.titleLabel?.font = UIFont.WDTAgoraRegular(12)
        userNameBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        userNameBtn.titleLabel?.textAlignment = .Left
        
        moreBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        moreBtn.titleLabel?.font = UIFont.WDTAgoraRegular(12)
        moreBtn.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        moreBtn.setTitle("More posts...", forState: .Normal)
        
        
        firstNameLbl.textColor = UIColor.grayColor()
        firstNameLbl.font = UIFont.WDTAgoraRegular(12)
        
        timeLbl.textColor = UIColor.grayColor()
        timeLbl.font = UIFont.WDTAgoraRegular(12)
        
        distanceLbl.textColor = UIColor.grayColor()
        distanceLbl.font = UIFont.WDTAgoraRegular(12)
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isHeightCalculated: Bool = false
    
    override func updateConstraints() {
        

        postPhoto.snp_remakeConstraints(closure: { (make) in
            make.top.equalTo(avaImage.snp_bottom).offset(10)
            make.left.equalTo(cardView).offset(10)
            make.right.equalTo(cardView).offset(-10)
            if let img = postPhoto.image {
                let scale = img.size.height / img.size.width
                make.height.equalTo(postPhoto.snp_width).multipliedBy(scale)
            } else {
                make.height.equalTo(postPhoto.snp_width).multipliedBy(0.625)
            }
            
        })
        
        postText.snp_remakeConstraints(closure: { (make) in
            if let _ = self.postPhoto.image {
                make.top.equalTo(postPhoto.snp_bottom).offset(10)
            } else {
                make.top.equalTo(avaImage.snp_bottom).offset(10)
            }
            make.left.equalTo(cardView).offset(10)
            make.right.equalTo(cardView).offset(-10)
            make.bottom.equalTo(cardView).offset(-25).priority(750)
            
        })

        if isHeightCalculated == false {

            cardView.snp_remakeConstraints { (make) in
                make.top.equalTo(contentView).offset(10)
                make.left.equalTo(contentView).offset(10)
                make.right.equalTo(contentView).offset(-10)
                make.bottom.equalTo(contentView).priority(751)
            }
            
            avaImage.snp_remakeConstraints(closure: { (make) in
                make.top.equalTo(cardView).offset(10)
                make.left.equalTo(cardView).offset(10)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            
            userNameBtn.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(avaImage.snp_right).offset(7)
                make.top.equalTo(cardView).offset(5)
            })
        
            firstNameLbl.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(avaImage.snp_right).offset(10)
                make.top.equalTo(userNameBtn.snp_bottom).offset(-4)
            })

            timeLbl.snp_remakeConstraints(closure: { (make) in
                make.right.equalTo(cardView).offset(-10)
                make.top.equalTo(cardView).offset(10)
            })
        
            distanceLbl.snp_remakeConstraints(closure: { (make) in
                make.right.equalTo(cardView).offset(-10)
                make.top.equalTo(timeLbl.snp_bottom).offset(5)
            })
        

            moreBtn.snp_remakeConstraints { (make) in
                make.top.equalTo(postText.snp_bottom).offset(2)
                make.right.equalTo(cardView).offset(-10)
            }

        
        }
            isHeightCalculated = true
        
        
        
        super.updateConstraints()
    }

    
    
    func fillCell(post: PFObject) {
        let user = post["user"] as! PFUser
        
        let username = user.username
        userNameBtn.setTitle(username, forState: .Normal)
        self.post = post
        self.user = user
    
        
        postText.text = post["postText"] as! String
        firstNameLbl.text = user["firstName"] as? String
        userNameBtn.hidden = false
        moreBtn.hidden = false
        
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
        let avaFile: PFFile? = user["ava"] as? PFFile
        
        if let avaFile = avaFile {
            avaImage.kf_setImageWithURL(NSURL(string: avaFile.url!)!)
        }
        
        
        if let photoFile = post["photoFile"]  {
            
            guard let photoHeight = post["photoHeight"] as? CGFloat else {
                return
            }
            guard let photoWidth = post["photoWidth"] as? CGFloat else {
                return
            }
            
            
            
            let pfFile: PFFile = photoFile as! PFFile
            let url = pfFile.url!
            postPhoto.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(color: UIColor.WDTBlueColor(), size: CGSizeMake(photoWidth, photoHeight)), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                
                
                self.updateConstraints()
                self.cardView.updateLayer()
                
                
            })


        } else {
            postPhoto.image = nil
            self.updateConstraints()
            self.cardView.updateLayer()
        }
        
        let hoursexpired = post["hoursexpired"] as! NSDate
        let timeLeft = hoursexpired.timeIntervalSince1970 - NSDate().timeIntervalSince1970
        
        timeLbl.text = NSDateComponentsFormatter.wdtLeftTime(Int(timeLeft)) + " left"
        
        if let postGeoPoint = post["geoPoint"] {
            distanceLbl.text = String(format: "%.1f mi", postGeoPoint.distanceInMilesTo(geoPoint))
        } else {
            distanceLbl.text = ""
        }
    }
    
    
    
    @IBAction func morePostsButtonPressed(sender: UIButton) {

    }
    

}
