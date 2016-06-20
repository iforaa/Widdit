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
        
        // dynamic collectionView height - dynamic cell
        self.tableView.backgroundColor = UIColor .whiteColor()
        self.tableView.registerClass(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        
        // title at the top
        self.navigationItem.title = "Activity"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Messages", style: .Done, target: self, action: #selector(messagesButtonTapped))
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        self.tableView.separatorStyle = .None
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.activity.requestDowns { (success) in
            self.tableView.reloadData()
        }
    }
    
    func messagesButtonTapped() {
        let destVC = MessagesVC()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activity.downs.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityCell
        let sender = self.activity.downs[indexPath.row]["by"] as! PFUser
        let post = self.activity.downs[indexPath.row]["post"] as! PFObject
        cell.fillCell(sender, post: post)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let destVC = ReplyViewController()
        let sender = self.activity.downs[indexPath.row]["by"] as! PFUser
        let post = self.activity.downs[indexPath.row]["post"] as! PFObject
        
        destVC.recipient = sender
        destVC.usersPost = post
        
        self.navigationController?.pushViewController(destVC, animated: true)

    }
    

}
