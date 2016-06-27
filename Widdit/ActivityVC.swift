//
//  ActivityVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse


class ActivityVC: UITableViewController {
    
    let activity = WDTActivity()
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activity"
        
        
        tableView.backgroundColor = UIColor .whiteColor()
        tableView.registerClass(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 60;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        activity.requestDowns { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.downs.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityCell
        cell.replyButton.tag = indexPath.row
        cell.replyButton.addTarget(self, action: #selector(replyButtonTapped), forControlEvents: .TouchUpInside)
        cell.fillCell(activity.downs[indexPath.row])
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = activity.downs[indexPath.row]["post"] as! PFObject
        let user = post["user"] as! PFUser
        let guest = MorePostsVC()
        guest.user = user
//        guest.geoPoint = self.geoPoint
        guest.collectionOfPosts = [post]
        self.navigationController?.pushViewController(guest, animated: true)
    }
    
    func replyButtonTapped(sender: AnyObject?) {
        
        let row = sender?.tag
        let destVC = ReplyViewController()
        
        
        let toUser = activity.downs[row!]["to"] as! PFUser
        let byUser = activity.downs[row!]["by"] as! PFUser
        
        
        let post = activity.downs[row!]["post"] as! PFObject
        
        if byUser.username == PFUser.currentUser()!.username {
            destVC.toUser = toUser
        } else {
            destVC.toUser = byUser
        }
        
        destVC.usersPost = post
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }

}
