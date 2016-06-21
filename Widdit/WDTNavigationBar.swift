//
//  WDTNavigationBar.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 21.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit


extension UINavigationBar {
    
    func setBottomBorderColor() {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        
        let shadowPath = UIBezierPath(rect: bottomBorderView.bounds)
        bottomBorderView.layer.masksToBounds = false
        bottomBorderView.layer.shadowColor = UIColor.blackColor().CGColor
        bottomBorderView.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        bottomBorderView.layer.shadowOpacity = 0.5
        bottomBorderView.layer.shadowPath = shadowPath.CGPath
        bottomBorderView.layer.cornerRadius = 4.0
        
        addSubview(bottomBorderView)
    }
}