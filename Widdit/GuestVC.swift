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
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        // Pull to Refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        
        self.tableView.registerClass(PostCell2.self, forCellReuseIdentifier: "PostCell")
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
        
        // Clean Guest Username or deduct the last guest username from guestName = Array
//        if !guestName.isEmpty {
//            guestName.removeLast()
//        }
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
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell2
        
        let post = self.collectionOfPosts[indexPath.row]
        
        // Connect objects with our information from arrays
        cell.userNameBtn.setTitle(self.user.username, forState: .Normal)
        cell.postText.text = post["postText"] as! String
        cell.firstNameLbl.text = user["firstName"] as? String
        cell.user = user
        cell.post = post
        cell.selectionStyle = .None
        
        if PFUser.currentUser()?.username == user.username {
            cell.replyBtn.hidden = true
            cell.imDownBtn.hidden = true
            cell.myPost = true
        } else {
            cell.replyBtn.hidden = false
            cell.imDownBtn.hidden = false
            cell.myPost = false
        }
        
        
        cell.userNameBtn.tag = indexPath.row
        cell.replyBtn.tag = indexPath.row
        cell.replyBtn.addTarget(self, action: #selector(replyBtnTapped), forControlEvents: .TouchUpInside)
        
        
        // Place Profile Picture
        self.user["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            cell.avaImage.image = UIImage(data: data!)
        }
        
        if let photoFile = post["photoFile"] {
            cell.postPhoto.image = UIImage()
            
            photoFile.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                cell.postPhoto.image = UIImage(data: data!)
            }
        } else {
            cell.postPhoto.image = nil
        }
        
        let hoursexpired = post["hoursexpired"] as! NSDate
        let timeLeft = hoursexpired.timeIntervalSince1970 - NSDate().timeIntervalSince1970
        
        cell.timeLbl.text = NSDateComponentsFormatter.wdtLeftTime(Int(timeLeft)) + " left"
        
        if let postGeoPoint = post["geoPoint"] {
            print(self.geoPoint)
            
            cell.distanceLbl.text = String(format: "%.1f mi", postGeoPoint.distanceInMilesTo(self.geoPoint))
        } else {
            cell.distanceLbl.text = ""
        }
        
        // manipulate down button depending on did user like it or not
        let didDown = PFQuery(className: "downs")
        didDown.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        didDown.whereKey("to", equalTo: user.username!)
        didDown.whereKey("post", equalTo: post)
        didDown.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            // if no any likes are found, else found likes
            if count == 0 {
                cell.imDownBtn.setTitle("I'm Down", forState: .Normal)
            } else {
                cell.imDownBtn.setTitle("Undown", forState: .Normal)
            }
        }
        
        cell.moreBtn.hidden = true
        
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
