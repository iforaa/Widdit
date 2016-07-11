//
//  WDTButton.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 08.07.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

extension UIButton {

    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color), forState: state)
    }
    
    
    func WDTButtonStyle(color: UIColor, title: String) {
        self.backgroundColor = color
        self.setTitle(NSLocalizedString(title, comment: ""), forState: .Normal)
        if color == UIColor.whiteColor() {
            self.setTitleColor(UIColor.WDTBlueColor(), forState: .Normal)
        } else {
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        self.setBackgroundColor(UIColor.lightGrayColor(), forUIControlState: .Highlighted)
        self.layer.cornerRadius = 4
        self.titleLabel?.font = UIFont.WDTAgoraRegular(17)
    }
    
    
}

extension UITextField {
    func WDTRoundedWhite(image: UIImage?, height: CGFloat) {
        
        let container: UIView = UIView()
        container.frame = CGRectMake(0, 0, 30, 30)
        
        let imgView = UIImageView(image: image)
        imgView.contentMode = .Right
        imgView.frame = CGRectMake(-13, 2.5, 20, 20)
        container.addSubview(imgView)
        
        self.leftView = container
        self.leftViewMode = .Always
        self.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0); // leftview indent
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = height / 2
    }
    
    func WDTRoundedDark(image: UIImage?, height: CGFloat) {
        let container: UIView = UIView()
        container.frame = CGRectMake(0, 0, 30, 30)
        
        let imgView = UIImageView(image: image)
        imgView.contentMode = .Right
        imgView.frame = CGRectMake(-13, 2.5, 20, 20)
        container.addSubview(imgView)
        
        self.leftView = container
        self.leftViewMode = .Always
        self.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0); // leftview indent
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderColor = UIColor.WDTBlueColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = height / 2
    }
    
    func WDTFontSettings(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.WDTAgoraRegular(16)])
        self.textColor = UIColor.whiteColor()
        self.font = UIFont.WDTAgoraRegular(16)
    }
}

