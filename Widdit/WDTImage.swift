//
//  WDTImage.swift
//  Widdit
//
//  Created by Igor Kuznetsov on 06.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit


extension UIImage {
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}