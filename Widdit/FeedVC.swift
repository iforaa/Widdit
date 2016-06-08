//
//  FeedVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class FeedVC: UITableViewController {
    
    // UI Objects
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    var collectionOfPosts = [PFObject]()
    var collectionOfAllPosts = [PFObject]()

    // Page Size
    var page : Int = 10


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title at the Top
        self.navigationItem.title = "The World"
        
        // Pull to Refresh
        refresher.addTarget(self, action: #selector(loadPosts), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        // Receive Notification from PostCell if Post is Downed, to update CollectionView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "downed", object: nil)

        // Receive Notification from NewPostVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploaded:", name: "uploaded", object: nil)
    
        self.tableView.registerClass(PostCell2.self, forCellReuseIdentifier: "PostCell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.separatorStyle = .None

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    // reloading func with posts after received notification
    func uploaded(notification: NSNotification) {
        loadPosts()
    }
    
    func loadPosts() {
        let query = PFQuery(className: "posts")
        query.limit = self.page
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.whereKeyExists("user")
        query.findObjectsInBackgroundWithBlock({ (posts: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let posts = posts {
                    self.collectionOfAllPosts = posts
                    
                    self.collectionOfAllPosts = self.collectionOfAllPosts.filter({
                        let currentDate = NSDate().toLocalTime()
                        let parseDate = $0.objectForKey("hoursexpired") as! NSDate
                        if currentDate.timeIntervalSince1970 >= parseDate.timeIntervalSince1970 {
                            let delete = PFObject(withoutDataWithClassName: "posts", objectId: $0.objectId)
                            delete.deleteInBackgroundWithBlock({ (success, err) in
                                if success {
                                    print("Successfully deleted expired post")
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                    })
                                } else {
                                    print("Failed to delete expired post: \(err)")
                                }
                            })
                            return false
                        } else {
                            return true
                        }
                    })
                    
                    self.collectionOfPosts = self.collectionOfAllPosts.reduce([], combine: { (acc: [PFObject], current: PFObject) -> [PFObject] in
                        if acc.contains( {
                            if $0["user"].objectId == current["user"].objectId {
                                return true
                            } else {
                                return false
                            }
                        }) {
                            return acc
                        } else {
                            let allPostsOfUser = self.collectionOfAllPosts.filter({$0["user"].objectId == current["user"].objectId
                            })
                            if let newest = allPostsOfUser.first {
                                return acc + [newest]
                            } else {
                                return acc
                            }
                        }
                    })
                }
            }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
            
        })
    }

    func loadMore() {
       /*
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
 */
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "segueToMorePosts" {
        let destVC = segue.destinationViewController as! UserMorePostsViewController
        let i = sender?.layer.valueForKey("index") as! NSIndexPath
        let post = self.collectionOfPosts[i.row]
        let user = post["user"] as! PFUser
        destVC.currentUser = user.username
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
        let user = post["user"] as! PFUser
        
        
        let username = user.username
        cell.userNameBtn.setTitle(username, forState: .Normal)
        cell.post = post

//        if self.numberOfPostsByUsername[username] > 1 {
//            cell.morePostsButton.hidden = false
//        } else {
//            cell.morePostsButton.hidden = true
//        }
        
        if self.collectionOfPosts.count == 0 {
            cell.postText.text = "Awaiting first post..."
            cell.userNameBtn.setTitle("Admin", forState: .Normal)
            cell.firstNameLbl.text = "Admin"
            cell.imDownBtn.hidden = true
            cell.replyBtn.hidden = true
            cell.userNameBtn.hidden = true
            cell.moreBtn.hidden = true
        } else {
            cell.replyBtn.tag = indexPath.row
            cell.replyBtn.addTarget(self, action: #selector(replyBtnTapped), forControlEvents: .TouchUpInside)
            cell.userNameBtn.tag = indexPath.row
            cell.userNameBtn.addTarget(self, action: #selector(usernameBtnTapped), forControlEvents: .TouchUpInside)
            
            cell.postText.text = post["postText"] as! String
            cell.firstNameLbl.text = user["firstName"] as? String
            cell.imDownBtn.hidden = false
            cell.userNameBtn.hidden = false
            cell.moreBtn.hidden = false
            
            if PFUser.currentUser()?.username == user.username {
                cell.replyBtn.hidden = true
                cell.imDownBtn.hidden = true
            } else {
                cell.replyBtn.hidden = false
                cell.imDownBtn.hidden = false
            }
            
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
        
        // Place Profile Picture
        user["ava"].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
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
    
    func usernameBtnTapped(sender: AnyObject) {
        // If user tapped on himself go home, else go to guest
        let post = self.collectionOfPosts[sender.tag]
        let user = post["user"] as! PFUser
        if user.username == PFUser.currentUser()?.username {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            let guest = GuestVC()
            guest.user = user
            guest.collectionOfPosts = self.collectionOfAllPosts.filter({
                let u = $0["user"] as! PFUser
                if u.username == user.username {
                    return true
                } else {
                    return false
                }
            })
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    

    
    
//    // clicked more button
//    @IBAction func moreBtn_click(sender: AnyObject) {
//        
//        // call index of button
//        let i = sender.layer.valueForKey("index") as! NSIndexPath
//        
//        // call cell to call further cell date
//        let cell = collectionView?.cellForItemAtIndexPath(i)  as! PostCell
//        
//        
//        // DELET ACTION
//        let delete = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
//            
//            // STEP 1. Delete row from tableView
//            self.usernameArray.removeAtIndex(i.row)
//            self.avaArray.removeAtIndex(i.row)
//            self.dateArray.removeAtIndex(i.row)
//            self.postsArray.removeAtIndex(i.row)
//            self.uuidArray.removeAtIndex(i.row)
//            
//            // STEP 2. Delete post from server
//            let postQuery = PFQuery(className: "posts")
//            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
//            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    for object in objects! {
//                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                            if success {
//                                
//                                // send notification to rootViewController to update shown posts
//                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
//                                
//                                // push back
//                                self.navigationController?.popViewControllerAnimated(true)
//                            } else {
//                                print(error!.localizedDescription)
//                            }
//                        })
//                    }
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
//            
//            
//        }
//        
//        
//        // COMPLAIN ACTION
//        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
//            
//            // send complain to server
//            let complainObj = PFObject(className: "complain")
//            complainObj["by"] = PFUser.currentUser()?.username
//            complainObj["to"] = cell.uuidLbl.text
//            complainObj["owner"] = cell.userNameBtn.titleLabel?.text
//            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                if success {
//                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
//                } else {
//                    self.alert("ERROR", message: error!.localizedDescription)
//                }
//            })
//        }
//        
//        // CANCEL ACTION
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        
//        // create menu controller
//        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
//        
//        
//        // if post belongs to user, he can delete post, else he can't
//        if cell.userNameBtn.titleLabel?.text == PFUser.currentUser()?.username {
//            menu.addAction(delete)
//            menu.addAction(cancel)
//        } else {
//            menu.addAction(complain)
//            menu.addAction(cancel)
//        }
//        
//        // show menu
//        self.presentViewController(menu, animated: true, completion: nil)
//    }
//    
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func openSlack(sender: UIButton) {

    }

   
}

extension Array where Element: Equatable {

  public func uniq() -> [Element] {
    var arrayCopy = self
    arrayCopy.uniqInPlace()
    return arrayCopy
  }

  mutating public func uniqInPlace() {
    var seen = [Element]()
    var index = 0
    for element in self {
      if seen.contains(element) {
        removeAtIndex(index)
        print(seen.count)
      } else {
        seen.append(element)
        index += 1
      }
    }
  }
}
