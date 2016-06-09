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

extension NSDateComponentsFormatter {
    class func wdtLeftTime(seconds: Int) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Abbreviated
        let components = NSDateComponents()

        let hours = seconds / 3600
        let minuts = (seconds - (3600 * hours)) / 60
        
        components.hour = hours
        components.minute = minuts
        
        return formatter.stringFromDateComponents(components)!
    }
}




extension NSDate {
    func toLocalTime() -> NSDate {
        let tz = NSTimeZone.localTimeZone()
        let seconds = tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: NSTimeInterval(seconds), sinceDate: self)
    }
}




