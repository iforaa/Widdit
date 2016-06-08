//
//  WDTDateFormatter.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 08.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import Foundation


extension NSDateFormatter {
    class func wdtDateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .MediumStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
}

extension NSDate {
    func toLocalTime() -> NSDate {
        let tz = NSTimeZone.localTimeZone()
        let seconds = tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: NSTimeInterval(seconds), sinceDate: self)
    }
}




