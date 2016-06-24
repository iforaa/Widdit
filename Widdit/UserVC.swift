//
//  HomeVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SAStickyHeader
import ImageViewer

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView: UITableView!
    var configuration: ImageViewerConfiguration!
    let imageProvider = WDTImageProvider()
    // Page Size
    var page : Int = 10
    
    var geoPoint: PFGeoPoint?
    let wdtPost = WDTPost()
    
    var user: PFUser = PFUser.currentUser()!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title at the top
        self.navigationItem.title = self.user.username?.uppercaseString
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: #selector(editButtonTapped))
        
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(60)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.tableView.registerClass(FeedFooter.self, forHeaderFooterViewReuseIdentifier: "FeedFooter")
        self.tableView.registerClass(PostCell.self, forCellReuseIdentifier: "PostCell")
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.separatorStyle = .None
        
        let header = SAStickyHeaderView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200), table: self.tableView, image: [])
        
        self.view.backgroundColor = UIColor.greenColor()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = header.bounds
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.6).CGColor as CGColorRef
        gradientLayer.colors = [color3, color4]
        gradientLayer.locations = [0.2, 1.0]
        header.layer.addSublayer(gradientLayer)
        
        
//        let firstName = UILabel(frame: CGRectZero)
//        header.addSubview(firstName)
//        firstName.font = UIFont.WDTAgoraRegular(16)
//        firstName.textColor = UIColor.whiteColor()
//        firstName.text = self.user["firstName"] as? String
//        firstName.snp_makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.bottom.equalTo(-20)
//        }
        
        self.tableView.tableHeaderView = header
        
        
        WDTAvatar.getAvatar(self.user, avaNum: 1) { (ava) in
            header.addImage(ava)
        }
        
        WDTAvatar.getAvatar(self.user, avaNum: 2) { (ava) in
            header.addImage(ava)
        }
        
        WDTAvatar.getAvatar(self.user, avaNum: 3) { (ava) in
            header.addImage(ava)
        }
        
        WDTAvatar.getAvatar(self.user, avaNum: 4) { (ava) in
            header.addImage(ava)
        }
        
        self.loadPosts()
    }
    
    func editButtonTapped() {
        let destVC = EditVC()
        destVC.view.backgroundColor = UIColor.whiteColor()
        let nc = UINavigationController(rootViewController: destVC)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    func loadPosts() {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            
            if error == nil {
                self.geoPoint = geoPoint
            }
        }
        wdtPost.postsOfUser = self.user
        wdtPost.requestPosts { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewWillAppear(animated: Bool) {
        self.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.wdtPost.collectionOfAllPosts.count
    }
    
    
    // Create table view rows
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = self.tableView!.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = self.wdtPost.collectionOfAllPosts[indexPath.section]
        
        cell.userNameBtn.tag = indexPath.section
        cell.moreBtn.tag = indexPath.section
        cell.moreBtn.addTarget(self, action: #selector(moreBtnTapped), forControlEvents: .TouchUpInside)
        cell.geoPoint = self.geoPoint
        cell.fillCell(post)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()

        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let post = self.wdtPost.collectionOfAllPosts[section]
        let user = post["user"] as! PFUser
        
        if PFUser.currentUser()?.username == user.username {
            return 0
        } else {
            return 55
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("FeedFooter")
        let footerView = footer as! FeedFooter
        let post = self.wdtPost.collectionOfAllPosts[section]
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
        
        let post = self.wdtPost.collectionOfAllPosts[sender.tag]
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
        let post = self.wdtPost.collectionOfAllPosts[sender.tag]
        destVC.recipient = post.objectForKey("user") as! PFUser
        destVC.usersPost = post
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func moreBtnTapped(sender: AnyObject) {
        let post = self.wdtPost.collectionOfAllPosts[sender.tag]
        let user = post["user"] as! PFUser
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
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        // implement log out
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            if error == nil {
                
                // remove logged in user from App memory
                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                NSUserDefaults.standardUserDefaults().synchronize()

                FBSDKLoginManager().logOut()
                PFUser.logOut()

                let storage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                for cookie in storage.cookies! {
                    storage.deleteCookie(cookie)
                }
                NSUserDefaults.standardUserDefaults().synchronize()

                FBSDKAccessToken.setCurrentAccessToken(nil)
                FBSDKProfile.setCurrentProfile(nil)

                let signIn = self.storyboard?.instantiateViewControllerWithIdentifier("SignInVC") as! SignInVC
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = signIn
                
            }
        }
    }
}
