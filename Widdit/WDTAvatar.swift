//
//  WDTAvatar.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 24.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import Foundation
import Parse

class WDTAvatar {
    class func getAvatar(user: PFUser, avaNum: Int, completion: (ava: UIImage?) -> Void) {
        
        let avaQuery: PFFile!
        
        if avaNum == 2 || avaNum == 3 || avaNum == 4 {
            avaQuery = user.objectForKey("ava" + String(avaNum)) as? PFFile
        } else {
            avaQuery = user.objectForKey("ava") as? PFFile
        }
        
        if let avaQuery = avaQuery {
            avaQuery.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                let img = UIImage(data: data!)
                completion(ava: img)
            }
        } else {
            completion(ava: nil)
        }
    }
}