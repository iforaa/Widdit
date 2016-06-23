//
//  FeedVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ImageViewer

class WDTImageProvider: ImageProvider {
    
    var image: UIImage = UIImage()
    
    func provideImage(completion: UIImage? -> Void) {
        completion(image)
    }
    
    func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        completion(image)
    }
}

class FeedVC: UITableViewController {
    
    // UI Objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    
    
    let buttonAssets = CloseButtonAssets(normal: UIImage(named:"DeletePhotoButton")!, highlighted: UIImage(named: "DeletePhotoButton"))
    var configuration: ImageViewerConfiguration!
    let imageProvider = WDTImageProvider()
    // Page Size
    var page : Int = 10
    
    var geoPoint: PFGeoPoint?
    let wdtPost = WDTPost()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBottomBorderColor()

        
        let shadowPath = UIBezierPath(rect: self.tabBarController!.tabBar.bounds)
        self.tabBarController!.tabBar.layer.masksToBounds = false
        self.tabBarController!.tabBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.tabBarController!.tabBar.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.tabBarController!.tabBar.layer.shadowOpacity = 0.5
        self.tabBarController!.tabBar.layer.shadowPath = shadowPath.CGPath
        self.tabBarController!.tabBar.layer.cornerRadius = 4.0
        
        
        
        self.configuration = ImageViewerConfiguration(imageSize: CGSize(width: 10, height: 10), closeButtonAssets: buttonAssets)
        
        // Title at the Top
        self.navigationItem.title = "The World"
        
        // Pull to Refresh
        refresher.addTarget(self, action: #selector(loadPosts), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        // Receive Notification from PostCell if Post is Downed, to update CollectionView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedVC.refresh), name: "downed", object: nil)

        // Receive Notification from NewPostVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FeedVC.uploaded(_:)), name: "uploaded", object: nil)
    
        self.tableView.registerClass(FeedFooter.self, forHeaderFooterViewReuseIdentifier: "FeedFooter")
        self.tableView.registerClass(PostCell.self, forCellReuseIdentifier: "PostCell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.separatorStyle = .None

        self.loadPosts()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    // reloading func with posts after received notification
    func uploaded(notification: NSNotification) {
        loadPosts()
        
    }
    
    func loadPosts() {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if error == nil {
                self.geoPoint = geoPoint
            }
        }
        
        wdtPost.requestPosts { (success) in
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
//            loadMore()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.wdtPost.collectionOfPosts.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = self.wdtPost.collectionOfPosts[indexPath.section]
        
        cell.userNameBtn.tag = indexPath.section
        cell.moreBtn.tag = indexPath.section
        cell.moreBtn.addTarget(self, action: #selector(moreBtnTapped), forControlEvents: .TouchUpInside)
        cell.geoPoint = self.geoPoint
        cell.fillCell(post)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! PostCell
        
        if let img = currentCell.postPhoto.image {
            
            self.imageProvider.image = img
            let imageViewer = ImageViewer(imageProvider: self.imageProvider, configuration: self.configuration, displacedView: currentCell.postPhoto)
            
            self.presentImageViewer(imageViewer)
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let post = self.wdtPost.collectionOfPosts[section]
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
        let post = self.wdtPost.collectionOfPosts[section]
        let user = post["user"] as! PFUser
        
        if PFUser.currentUser()?.username == user.username {
            return UIView()
        } else {
            
            footerView.hideSubvies(false)
            
            footerView.imDownBtn.tag = section
            footerView.replyBtn.tag = section
            footerView.replyBtn.addTarget(self, action: #selector(replyBtnTapped), forControlEvents: .TouchUpInside)
            footerView.imDownBtn.addTarget(self, action: #selector(downBtnTapped), forControlEvents: .TouchUpInside)
            footerView.imDownBtn.setTitle("I'm Down", forState: .Normal)
            WDTActivity.isDown(user, post: post) { (down) in
                if down == true {
                    footerView.imDownBtn.setTitle("I'm Down", forState: .Normal)
                } else {
                    footerView.imDownBtn.setTitle("Undown", forState: .Normal)
                }
            }
        }
        
        return footerView

    }
    
    func downBtnTapped(sender: AnyObject) {

        let title = sender.titleForState(.Normal)
        
        let post = self.wdtPost.collectionOfPosts[sender.tag]
        let user = post["user"] as! PFUser
        
        if title == "I'm Down" {
            print("Downed")
            sender.setTitle("Undown", forState: .Normal)
            WDTActivity.addActivity(user, post: post, type: .Down)
            
        } else {
            print("UnDown")
            sender.setTitle("I'm Down", forState: .Normal)
            WDTActivity.deleteActivity(user, type: .Down)
        }
    }
    
    func replyBtnTapped(sender: AnyObject) {
        let destVC = ReplyViewController()
        let post = self.wdtPost.collectionOfPosts[sender.tag]
        destVC.recipient = post.objectForKey("user") as! PFUser
        destVC.usersPost = post
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func moreBtnTapped(sender: AnyObject) {
        // If user tapped on himself go home, else go to guest
        let post = self.wdtPost.collectionOfPosts[sender.tag]
        let user = post["user"] as! PFUser
//        if user.username == PFUser.currentUser()?.username {
//            let home = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
//            self.navigationController?.pushViewController(home, animated: true)
//        } else {
            let guest = GuestVC()
            guest.user = user
            guest.geoPoint = self.geoPoint
            guest.collectionOfPosts = self.wdtPost.collectionOfAllPosts.filter({
                let u = $0["user"] as! PFUser
                if u.username == user.username {
                    return true
                } else {
                    return false
                }
            })
            self.navigationController?.pushViewController(guest, animated: true)
//        }
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

   
}




