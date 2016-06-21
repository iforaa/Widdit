//
//  GuestVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class GuestVC: UITableViewController {
    
    
    // UI Objects
    var refresher : UIRefreshControl!
    var page : Int = 12

    var user: PFUser!
    var collectionOfPosts = [PFObject]()
    var geoPoint: PFGeoPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow Vertical Scroll
        self.tableView.alwaysBounceVertical = true
        
        // Background Color
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        // Swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GuestVC.back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        // Pull to Refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(GuestVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        
        self.tableView.registerClass(PostCell.self, forCellReuseIdentifier: "PostCell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.separatorStyle = .None

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.title = self.user.username?.uppercaseString
    }

    func back(sender: UIBarButtonItem) {
        
        // Push Back
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refresh() {
        refresher.endRefreshing()
    }
    
    
    // load more while scrolling down
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
//            self.loadMore()
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectionOfPosts.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = self.collectionOfPosts[indexPath.row]
       
        cell.userNameBtn.tag = indexPath.row
//        cell.replyBtn.tag = indexPath.row
//        cell.replyBtn.addTarget(self, action: #selector(replyBtnTapped), forControlEvents: .TouchUpInside)
        cell.geoPoint = self.geoPoint
        cell.fillCell(post)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func replyBtnTapped(sender: AnyObject) {
        let destVC = ReplyViewController()
        let post = self.collectionOfPosts[sender.tag]
        destVC.recipient = post.objectForKey("user") as! PFUser
        destVC.usersPost = post
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
  
}
