//
//  HeaderView.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class HeaderView: UICollectionReusableView {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()

        // round ava
        avaImg.layer.cornerRadius = 8
        avaImg.clipsToBounds = true
        
    }
    
}
