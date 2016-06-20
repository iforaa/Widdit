//
//  MessagesVC.swift
//  Widdit
//
//  Created by Игорь Кузнецов on 20.06.16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class MessagesVC: UITableViewController {
    let activity = WDTActivity()
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dynamic collectionView height - dynamic cell
        self.tableView.backgroundColor = UIColor .whiteColor()
        self.tableView.registerClass(ActivityChatCell.self, forCellReuseIdentifier: "ActivityChatCell")
        // title at the top
        self.navigationItem.title = "Messages"

        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        self.tableView.separatorStyle = .None
        
        self.activity.requestChats { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func messagesButtonTapped() {
        let destVC = MessagesVC()
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activity.chats.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("ActivityChatCell", forIndexPath: indexPath) as! ActivityChatCell
        
        let sender = self.activity.chats[indexPath.row]["sender"] as! PFUser
        let post = self.activity.chats[indexPath.row]["post"] as! PFObject
        
        cell.fillCell(sender, post: post)
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let destVC = ReplyViewController()
        let sender = self.activity.chats[indexPath.row]["sender"] as! PFUser
        let post = self.activity.chats[indexPath.row]["post"] as! PFObject
        
        destVC.recipient = sender
        destVC.usersPost = post
        
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    
}
