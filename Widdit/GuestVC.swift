//
//  GuestVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ImageViewer

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
        tableView.alwaysBounceVertical = true
        
        // Background Color
        tableView.backgroundColor = UIColor.whiteColor()
        
        // Swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GuestVC.back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(backSwipe)
        
        // Pull to Refresh
        refresher = UIRefreshControl()
        
        refresher.addTarget(self, action: #selector(GuestVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
        tableView.registerClass(FeedFooter.self, forHeaderFooterViewReuseIdentifier: "FeedFooter")
        tableView.registerClass(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 150.0;
        tableView.separatorStyle = .None

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = user.username?.uppercaseString
    }

    func back(sender: UIBarButtonItem) {
        
        // Push Back
        navigationController?.popViewControllerAnimated(true)
    }
    
    func refresh() {
        refresher.endRefreshing()
    }
    
    
    // load more while scrolling down
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - view.frame.size.height {
//            self.loadMore()
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionOfPosts.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = collectionOfPosts[indexPath.row]
       
        cell.userNameBtn.tag = indexPath.section
        cell.geoPoint = self.geoPoint
        cell.fillCell(post)
        cell.moreBtn.hidden = true
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! PostCell
        
        if let img = currentCell.postPhoto.image {
            
            imageProvider.image = img
            let imageViewer = ImageViewer(imageProvider: imageProvider, configuration: configuration, displacedView: currentCell.postPhoto)
            
            presentImageViewer(imageViewer)
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let post = collectionOfPosts[section]
        let user = post["user"] as! PFUser
        
        if PFUser.currentUser()?.username == user.username {
            return 0
        } else {
            return 55
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("FeedFooter")
        let footerView = footer as! FeedFooter
        let post = collectionOfPosts[section]
        let user = post["user"] as! PFUser
        
        if PFUser.currentUser()?.username == user.username {
            return nil
        } else {
            
            footerView.setDown(user, post: post)
            footerView.imDownBtn.tag = section
            footerView.replyBtn.tag = section
            footerView.replyBtn.addTarget(self, action: #selector(replyBtnTapped), forControlEvents: .TouchUpInside)
            footerView.imDownBtn.addTarget(self, action: #selector(downBtnTapped), forControlEvents: .TouchUpInside)
            
        }
        
        return footerView
    }
    
    func downBtnTapped(sender: AnyObject) {
        let button: UIButton = sender as! UIButton
        let post = collectionOfPosts[button.tag]
        let user = post["user"] as! PFUser
        
        if button.selected == true {
            print("UnDown")
            button.selected = false
            WDTActivity.deleteActivity(user, type: .Down)
        } else {
            print("Downed")
            button.selected = true
            WDTActivity.addActivity(user, post: post, type: .Down)
        }
    }
    
    func replyBtnTapped(sender: AnyObject) {
        let destVC = ReplyViewController()
        let post = collectionOfPosts[sender.tag]
        destVC.recipient = post.objectForKey("user") as! PFUser
        destVC.usersPost = post
        navigationController?.pushViewController(destVC, animated: true)
    }
  
}
