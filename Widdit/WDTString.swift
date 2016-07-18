//
//  WDTString.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 14.07.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

extension String {
    func validateEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = self.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
}
