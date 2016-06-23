//
//  WDTActivity.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 20.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import Foundation
import Parse

class WDTActivity {
    
    enum WDTActivityType: String {
        case Down = "down"
    }

    let currentUser = PFUser.currentUser()!
    var chats = [PFObject]()
    var downs = [PFObject]()
    
    
    class func isDown(user: PFUser, post: PFObject, completion: (down: Bool) -> Void) {
        let didDown = PFQuery(className: "Activity")
        didDown.whereKey("by", equalTo: PFUser.currentUser()!)
        didDown.whereKey("to", equalTo: user)
        didDown.whereKey("post", equalTo: post)
        didDown.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            // if no any likes are found, else found likes
            if count == 0 {
                completion(down: true)
            } else {
                completion(down: false)
            }
        }
    }
    
    class func addActivity(user: PFUser, post: PFObject, type: WDTActivityType) {
        WDTPush.sendPushAfterDownTapped(user.username!, postId: post.objectId!)
        
        let activityObj = PFObject(className: "Activity")
        
        activityObj["by"] = PFUser.currentUser()
        activityObj["to"] = user
        activityObj["post"] = post
        activityObj["postText"] = post["postText"]
        activityObj["type"] = type.rawValue
        
        activityObj.saveEventually()
    }
    
    class func deleteActivity(user: PFUser, type: WDTActivityType) {
    
        let activityQuery = PFQuery(className: "Activity")
        activityQuery.whereKey("by", equalTo: PFUser.currentUser()!)
        activityQuery.whereKey("to", equalTo: user)
        activityQuery.whereKey("type", equalTo: type.rawValue)
        
        activityQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object in objects! {
                    object.deleteEventually()
                }
            }
        })
    }
    
    
    func requestDowns(completion: (success: Bool) -> Void) {
        let downsQuery = PFQuery(className: "Activity")
        downsQuery.includeKey("post")
        downsQuery.includeKey("by")
        downsQuery.whereKey("to", equalTo: self.currentUser)
        downsQuery.addDescendingOrder("createdAt")
        
        downsQuery.findObjectsInBackgroundWithBlock { (downs: [PFObject]?, error: NSError?) in
            if let downs = downs {
                self.downs = downs.filter({
                    if let _ = $0["post"] {
                        return true
                    } else {
                        return false
                    }
                })
                completion(success: true)
            } else {
                completion(success: false)
            }
        }
    }

    func requestChats(competion: (success: Bool) -> Void) {
        
        let repliesToMeQuery = PFQuery(className: "replies")
        repliesToMeQuery.whereKey("recipient", equalTo: currentUser)
        
        let repliesFromMeQuery = PFQuery(className: "replies")
        repliesFromMeQuery.whereKey("sender", equalTo: currentUser)
        
        let replyQuery = PFQuery.orQueryWithSubqueries([repliesToMeQuery, repliesFromMeQuery])
        replyQuery.includeKey("sender")
        replyQuery.includeKey("recipient")
        replyQuery.includeKey("post")
        replyQuery.addDescendingOrder("createdAt")
        
        replyQuery.findObjectsInBackgroundWithBlock { (replies: [PFObject]?, error: NSError?) -> Void in
            guard let replies = replies else {return}
            
            // filter replies to get chats
            self.chats = replies.filter({
                if let _ = $0["post"] {
                    return true
                } else {
                    return false
                }
            })
            
            self.chats = replies.reduce([], combine: { (acc: [PFObject], current: PFObject) -> [PFObject] in
                if acc.contains( {
                    if $0["sender"].objectId == current["sender"].objectId{
                        return true
                    } else {
                        return false
                    }
                }) {
                    return acc
                } else {
                    return acc + [current]
                }
            }).filter({ // if post exists
                if let _ = $0["post"] {
                    if  $0["sender"].username != PFUser.currentUser()?.username {
                        return true
                    } else {
                        return false
                    }
                    
                } else {
                    return false
                }
            })
            
            
            competion(success: true)

        }
    }
}