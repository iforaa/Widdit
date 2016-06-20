//
//  WDTArray.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 20.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                removeAtIndex(index)
                print(seen.count)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}