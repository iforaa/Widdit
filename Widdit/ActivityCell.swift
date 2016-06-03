//
//  ActivityCell.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var postText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Rounded Square Image
        avaImg.layer.cornerRadius = 8
        avaImg.clipsToBounds = true
    }
    
}


class ActivityChatCell: UICollectionViewCell {
    
    // UI objects
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLbl.textColor = UIColor.WDTBlueColor()
    }
    
}


