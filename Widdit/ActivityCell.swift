//
//  ActivityCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class ActivityCell: UITableViewCell {
    var avaImg: UIImageView = UIImageView()
    var username: UILabel = UILabel()
    var title: UILabel = UILabel()
    var postText: UILabel = UILabel()
    
    var downed: UILabel = UILabel()
    var replyButton: UIButton = UIButton(type: .Custom)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureSubviews() {
        
        backgroundColor = UIColor.WDTGrayBlueColor()
        selectionStyle = .None
        contentView.addSubview(avaImg)

        contentView.addSubview(username)
        username.font = UIFont.WDTAgoraMedium(16)

        
        contentView.addSubview(title)
        title.font = UIFont.WDTAgoraRegular(16)

        contentView.addSubview(postText)
        postText.numberOfLines = 2
        postText.font = UIFont.WDTAgoraRegular(14)
        postText.textColor = UIColor.grayColor()
        
        contentView.addSubview(downed)
        downed.textColor = UIColor.WDTBlueColor()
        downed.font = UIFont.WDTAgoraMedium(12)
        downed.hidden = true
        
        contentView.addSubview(replyButton)
        replyButton.setTitle("Reply", forState: .Normal)
        replyButton.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        replyButton.titleLabel?.font = UIFont.WDTAgoraRegular(16)
        replyButton.selected = true

    }
    
    func fillCell(activityObject: PFObject) {
        let postText = activityObject["postText"] as! String
        let byUser = activityObject["by"] as! PFUser
        let type = WDTActivity.WDTActivityType(rawValue: activityObject["type"] as! String)
        
        
        byUser["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            self.avaImg.image = UIImage(data: data!)
        }
        
        self.postText.text = postText
        
        
        if byUser.username == PFUser.currentUser()!.username {
            downed.text = "Downed"
        } else {
            let firstName = byUser["firstName"] as! String
            downed.text = "Downed"
        }
        
        
        
        if let whoRepliedLast = activityObject["whoRepliedLast"] as? PFUser {
            if whoRepliedLast.username == PFUser.currentUser()!.username {
                username.text = "You"
                title.text = " replied for this post"
            } else {
                username.text = whoRepliedLast.username
                title.text = " replied for this post"
            }
            
            if type == .Down {
                downed.hidden = false
            } else {
                downed.hidden = true
            }
            
        } else {
            downed.hidden = true
            if byUser.username == PFUser.currentUser()!.username {
                username.text = "You"
                title.text = " down for this post"
                
            } else {
                let firstName = byUser["firstName"] as! String
                username.text = firstName
                title.text = " is down for your post"
            }
        }
    }
    
    
    override func updateConstraints() {
        
        avaImg.snp_remakeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        username.snp_remakeConstraints { (make) in
            make.left.equalTo(avaImg.snp_right).offset(10)
            make.top.equalTo(contentView).offset(7)
        }
        
        title.snp_remakeConstraints { (make) in
            make.left.equalTo(username.snp_right)
            make.top.equalTo(contentView).offset(7)
        }
        
        postText.snp_remakeConstraints { (make) in
            make.left.equalTo(avaImg.snp_right).offset(10)
            make.top.equalTo(title.snp_bottom).offset(5)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        downed.snp_remakeConstraints { (make) in
            make.left.equalTo(avaImg.snp_right).offset(10)
            make.top.equalTo(postText.snp_bottom).offset(5)
            make.bottom.equalTo(contentView).offset(-5).priority(750)
        }
        
        replyButton.snp_remakeConstraints { (make) in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)

        }
        
        super.updateConstraints()
    }
}


