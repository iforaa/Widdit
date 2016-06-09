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
            self.loadMore()
        }
    }
    
    // Paging
    func loadMore() {
        /*
        // if there is more objects
        if page <= postTxtArray.count {
            
            // increase page size
            page = page + 12
            
            // load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: guestName.last!)
            query.limit = page
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    // clean up
                    self.uuidArray.removeAll(keepCapacity: false)
                    self.postTxtArray.removeAll(keepCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.uuidArray.append(object.valueForKey("uuid") as! String)
                        self.postTxtArray.append(object.valueForKey("posts") as! String)
                    }
                    
                    print("loaded +\(self.page)")
                    self.collectionView?.reloadData()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        }
 */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    // header config
    
    /*
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! HeaderView
        
        // Step 1 Load Data of Guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestName.last!)
        infoQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // Shown wrong user
                if objects!.isEmpty {
                    // Call alert
                    let alert = UIAlertController(title: "\(guestName.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "Got it", style: .Default, handler: { (UIAlertAction) -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                // Find related to user information
                for object in objects! {
                    header.firstNameLbl.text = (object.objectForKey("firstName") as? String)?.uppercaseString
                    header.bioLbl.text = object.objectForKey("bio") as? String
                    header.bioLbl.sizeToFit()
                    header.userName.text = object.objectForKey("userName") as? String
                    let avaFile : PFFile = (object.objectForKey("ava") as? PFFile)!
                    avaFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                        header.avaImg.image = UIImage(data: data!)
                    })
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        

        return header
        
    }*/

}
