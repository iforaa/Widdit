//
//  WidditColor.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 31.05.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(r: Float, g: Float, b: Float, a: Float) {
        self.init(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
   
    class func WDTGrayBlueColor() -> UIColor {
        return UIColor(r: 249, g: 249, b: 249, a: 1)
    }
    
    class func WDTBlueColor() -> UIColor {
        return UIColor(r: 59, g: 122, b: 218, a: 1)
    }
}

