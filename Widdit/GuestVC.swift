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
        
        cell.timeLbl.text = NSDateFormatter.wdtDateFormatter().stringFromDate(post["hoursexpired"] as! NSDate)
        
        return cell
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
