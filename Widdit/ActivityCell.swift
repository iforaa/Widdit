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
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureSubviews() {
        
        self.backgroundColor = UIColor.WDTGrayBlueColor()
        self.selectionStyle = .None
        self.contentView.addSubview(self.avaImg)

        
        self.contentView.addSubview(self.username)
        self.username.font = UIFont.WDTAgoraMedium(16)

        
        self.contentView.addSubview(self.title)
        self.title.font = UIFont.WDTAgoraRegular(16)

        
        self.contentView.addSubview(self.postText)
        self.postText.numberOfLines = 2
        self.postText.font = UIFont.WDTAgoraRegular(14)
        self.postText.textColor = UIColor.grayColor()

    }
    
    func fillCell(user: PFUser, post: PFObject) {
        user["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            self.avaImg.image = UIImage(data: data!)
        }
        
        self.postText.text = post["postText"] as? String
        
        let firstName = user["firstName"] as! String
        self.username.text = firstName
        self.title.text = " is down for your post"
        
    }
    
    
    override func updateConstraints() {
        
        self.avaImg.snp_remakeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.username.snp_remakeConstraints { (make) in
            make.left.equalTo(self.avaImg.snp_right).offset(10)
            make.top.equalTo(self.contentView).offset(7)
        }
        
        self.title.snp_remakeConstraints { (make) in
            make.left.equalTo(self.username.snp_right)
            make.top.equalTo(self.contentView).offset(7)
        }
        
        self.postText.snp_remakeConstraints { (make) in
            make.left.equalTo(self.avaImg.snp_right).offset(10)
            make.top.equalTo(self.title.snp_bottom).offset(5)
            make.right.equalTo(self.contentView).offset(-20)
            make.bottom.equalTo(self.contentView).offset(-20).priority(750)
        }
        
        super.updateConstraints()
    }
}


class ActivityChatCell: UITableViewCell {
    
    var avaImg: UIImageView = UIImageView()
    var firstName: UILabel = UILabel()
    var postText: UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureSubviews() {
        self.backgroundColor = UIColor.WDTGrayBlueColor()
        self.selectionStyle = .None
        
        self.contentView.addSubview(self.avaImg)
        
        self.contentView.addSubview(self.firstName)
        self.firstName.font = UIFont.WDTAgoraRegular(16)
        
        self.contentView.addSubview(self.postText)
        self.postText.numberOfLines = 2
        self.postText.font = UIFont.WDTAgoraRegular(14)
        self.postText.textColor = UIColor.grayColor()
    }
    
    func fillCell(user: PFUser, post: PFObject) {
        user["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            self.avaImg.image = UIImage(data: data!)
        }
        self.postText.text = post["postText"] as? String
        let firstName = user["firstName"] as! String
        self.firstName.text = firstName
        
    }
    
    
    override func updateConstraints() {
        
        self.avaImg.snp_remakeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.firstName.snp_remakeConstraints { (make) in
            make.left.equalTo(self.avaImg.snp_right).offset(10)
            make.top.equalTo(self.contentView).offset(7)
        }
        
        self.postText.snp_remakeConstraints { (make) in
            make.left.equalTo(self.avaImg.snp_right).offset(10)
            make.top.equalTo(self.firstName.snp_bottom).offset(5)
            make.right.equalTo(self.contentView).offset(-20)
            make.bottom.equalTo(self.contentView).offset(-20).priority(750)
        }
        
        super.updateConstraints()
    }
}


