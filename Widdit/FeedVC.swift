//
//  FeedVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse


class FeedVC: UICollectionViewController {
    
    // UI Objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var countBtn: UIBarButtonItem!
    var refresher = UIRefreshControl()
    
    // Arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [NSDate?]()
    var postsArray = [String]()
    var uuidArray = [String]()
    var usersArray = [String]()
    var firstNameArray = [String]()
    var countArray = [String]()
    
    // Page Size
    var page : Int = 10
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title at the Top
        self.navigationItem.title = "The World"
        
        // Pull to Refresh
        refresher.addTarget(self, action: "loadPosts", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        // Receive Notification from PostCell if Post is Downed, to update CollectionView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "downed", object: nil)
        
        // Indicator's x (horizontal) center
//        indicator.center.x = collectionView!.center.x
        
        // Receive Notification from NewPostVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploaded:", name: "uploaded", object: nil)
        
        // Calling function to load posts
        loadPosts()
        
        self.collectionView?.backgroundColor = UIColor .whiteColor()

    }
    
    
    func refresh() {
        collectionView?.reloadData()
    }
    
    // reloading func with posts after received notification
    func uploaded(notification: NSNotification) {
        loadPosts()
    }
    
    
    func loadPosts() {
        
        // Step 1 : Find Posts Related to the entire user base
        let userQuery = PFQuery(className: "User")
        userQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // Clean Up
                self.usersArray.removeAll(keepCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.usersArray.append(object.objectForKey("User") as! String)
                    
                }
                
                // Append current user to see own posts in feed
                self.usersArray.append(PFUser.currentUser()!.username!)
                
                // Step 2 : Find Posts made by the entire user base
                let query = PFQuery(className: "posts")
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        
                        
                        // Clean Up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.dateArray.removeAll(keepCapacity: false)
                        self.postsArray.removeAll(keepCapacity: false)
                        self.uuidArray.removeAll(keepCapacity: false)
                        self.firstNameArray.removeAll(keepCapacity: false)
                        
                        // Find Related Objects
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.dateArray.append(object.createdAt)
                            self.postsArray.append(object.objectForKey("postText") as! String)
                            self.uuidArray.append(object.objectForKey("uuid") as! String)
                            self.firstNameArray.append(object.objectForKey("firstName") as! String)
                        }
                        
                        // Reload Collection View and End Spinning of Refresher
                        self.collectionView?.reloadData()
                        self.refresher.endRefreshing()
                    } else {
                        print(error?.localizedDescription)
                    }
                })
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func loadMore() {
        
        // if posts on the server are more than shown
        if page <= usernameArray.count {
            
            // start animating indicator
            indicator.startAnimating()
            
            // increase page size to load +10 posts
            page = page + 10
            
            // Step 1 : Find Posts Related to the entire user base
            let userQuery = PFQuery(className: "User")
            userQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    // Clean Up
                    self.usersArray.removeAll(keepCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.usersArray.append(object.objectForKey("User") as! String)
                        
                    }
                    
                    // Append current user to see own posts in feed
                    self.usersArray.append(PFUser.currentUser()!.username!)
                    
                    // Step 2 : Find Posts made by the entire user base
                    let query = PFQuery(className: "posts")
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil {
                            
                            
                            // Clean Up
                            self.usernameArray.removeAll(keepCapacity: false)
                            self.avaArray.removeAll(keepCapacity: false)
                            self.dateArray.removeAll(keepCapacity: false)
                            self.postsArray.removeAll(keepCapacity: false)
                            self.uuidArray.removeAll(keepCapacity: false)
                            self.firstNameArray.removeAll(keepCapacity: false)
                            
                            // Find Related Objects
                            for object in objects! {
                                self.usernameArray.append(object.objectForKey("username") as! String)
                                self.avaArray.append(object.objectForKey("ava") as! PFFile)
                                self.dateArray.append(object.createdAt)
                                self.postsArray.append(object.objectForKey("postText") as! String)
                                self.uuidArray.append(object.objectForKey("uuid") as! String)
                                self.firstNameArray.append(object.objectForKey("firstName") as! String)
                            }
                            
                            // Reload Collection View and End Spinning of Refresher
                            self.collectionView?.reloadData()
                            self.refresher.endRefreshing()
                            self.indicator.stopAnimating()
                        } else {
                            print(error?.localizedDescription)
                        }
                    })
                    
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "segueToSlack" {
        let destVC = segue.destinationViewController as! ReplyViewController
        let i = sender?.layer.valueForKey("index") as! NSIndexPath
        destVC.toUser = usernameArray[i.row]
      }
    }

    // MARK: UICollectionViewDataSource

    	


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return usernameArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        
        // Connect objects with our information from arrays
        cell.userNameBtn.setTitle(usernameArray[indexPath.row], forState: .Normal)
        cell.userNameBtn.sizeToFit()
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.postText.text = postsArray[indexPath.row]
//        cell.postText.sizeToFit()
        cell.firstNameLbl.text = firstNameArray[indexPath.row]
        
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor .blackColor().CGColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        
        // manipulate down button depending on did user like it or not
        let didDown = PFQuery(className: "downs")
        didDown.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        didDown.whereKey("to", equalTo: cell.uuidLbl.text!)
        didDown.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            // if no any likes are found, else found likes
            if count == 0 {
                cell.imDownBtn.setTitle("I'm Down", forState: .Normal)
            } else {
                cell.imDownBtn.setTitle("Undown", forState: .Normal)
            }
        }

        // Place Profile Picture
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            cell.avaImage.image = UIImage(data: data!)
        }
        
        
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")

        cell.replyBtn.layer.setValue(indexPath, forKey: "index")
        
        // Calculate Post Date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        // Logic what to show: seconds, minutes, hours, days or weeks
        if difference.second <= 0 {
            cell.timeLbl.text = "now"
        }
        if difference.second > 0 && difference.minute == 0 {
            cell.timeLbl.text = "\(difference.second)s."
        }
        if difference.minute > 0 && difference.hour == 0 {
            cell.timeLbl.text = "\(difference.minute)m."
        }
        if difference.hour > 0 && difference.day == 0 {
            cell.timeLbl.text = "\(difference.hour)h."
        }
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.timeLbl.text = "\(difference.day)d."
        }
        if difference.weekOfMonth > 0 {
            cell.timeLbl.text = "\(difference.weekOfMonth)w."
        }
        
        // assign index
        cell.userNameBtn.layer.setValue(indexPath, forKey: "index")
        
    
    
        return cell
    }

    @IBAction func usernameBtnTapped(sender: AnyObject) {
        
        // Call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // Call cell to call further cell data
        let cell = collectionView?.cellForItemAtIndexPath(i) as! PostCell
        
        // If user tapped on himself go home, else go to guest
        if cell.userNameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestName.append(cell.userNameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("GuestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    

    
    
    // clicked more button
    @IBAction func moreBtn_click(sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell date
        let cell = collectionView?.cellForItemAtIndexPath(i)  as! PostCell
        
        
        // DELET ACTION
        let delete = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
            
            // STEP 1. Delete row from tableView
            self.usernameArray.removeAtIndex(i.row)
            self.avaArray.removeAtIndex(i.row)
            self.dateArray.removeAtIndex(i.row)
            self.postsArray.removeAtIndex(i.row)
            self.uuidArray.removeAtIndex(i.row)
            
            // STEP 2. Delete post from server
            let postQuery = PFQuery(className: "posts")
            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                
                                // send notification to rootViewController to update shown posts
                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
                                
                                // push back
                                self.navigationController?.popViewControllerAnimated(true)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            
        }
        
        
        // COMPLAIN ACTION
        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
            
            // send complain to server
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.currentUser()?.username
            complainObj["to"] = cell.uuidLbl.text
            complainObj["owner"] = cell.userNameBtn.titleLabel?.text
            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
                } else {
                    self.alert("ERROR", message: error!.localizedDescription)
                }
            })
        }
        
        // CANCEL ACTION
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        // create menu controller
        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
        
        
        // if post belongs to user, he can delete post, else he can't
        if cell.userNameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            menu.addAction(delete)
            menu.addAction(cancel)
        } else {
            menu.addAction(complain)
            menu.addAction(cancel)
        }
        
        // show menu
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func openSlack(sender: UIButton) {

    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
