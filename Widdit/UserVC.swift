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
import ImageViewer

class UserVC: WDTFeed {

    
//    var tableView: UITableView!
    var configuration: ImageViewerConfiguration!
    let imageProvider = WDTImageProvider()
    // Page Size
    var page : Int = 10
    
    var geoPoint: PFGeoPoint?
    let wdtPost = WDTPost()
    
    var user: PFUser = PFUser.currentUser()!
    var headerHeight: CGFloat = 200.0
    var headerView: UIView!
    
    var avatars: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title at the top
        navigationItem.title = self.user.username?.uppercaseString
        
        if user.username == PFUser.currentUser()?.username {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: #selector(editButtonTapped))
        }
        
        configuration = ImageViewerConfiguration(imageSize: CGSize(width: 10, height: 10), closeButtonAssets: buttonAssets)
//        tableView = UITableView(frame: CGRectZero, style: .Grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(self.tableView)
//        tableView.snp_makeConstraints { (make) in
//            make.top.equalTo(view).offset(60)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.bottom.equalTo(view)
//        }
        
        tableView.registerClass(FeedFooter.self, forHeaderFooterViewReuseIdentifier: "FeedFooter")
        tableView.registerClass(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 150.0;
        tableView.separatorStyle = .None
        
        headerHeight = 200
        
        let scrollView = UIScrollView(frame: CGRectMake(0, 0, view.frame.width, headerHeight))
        scrollView.backgroundColor = UIColor.whiteColor()
        
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        
        let wdtHeader = WDTHeader.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)));
        
        WDTAvatar.countAvatars(user) { (num) in
            scrollView.contentSize = CGSizeMake(self.view.frame.width * CGFloat(num), self.headerHeight)
        }
        avatars = []
        
        WDTAvatar.getAvatar(user, avaNum: 1) { (ava) in
            if let ava = ava {
                self.avatars.append(ava)
                
                WDTAvatar.getAvatar(self.user, avaNum: 2) { (ava2) in
                    if let ava2 = ava2 {
                        self.avatars.append(ava2)
                        wdtHeader.setImages([ava, ava2])
                    }
                }
            }
        }
        
        WDTAvatar.getAvatar(user, avaNum: 2) { (ava) in
            if let ava = ava {
                self.avatars.append(ava)
                self.placeAvatars(scrollView)
            }
        }
        
        WDTAvatar.getAvatar(user, avaNum: 3) { (ava) in
            if let ava = ava {
                self.avatars.append(ava)
                self.placeAvatars(scrollView)
            }
            
        }
        
        WDTAvatar.getAvatar(user, avaNum: 4) { (ava) in
            if let ava = ava {
                self.avatars.append(ava)
                self.placeAvatars(scrollView)
            }
            
        }
    
        
        tableView.tableHeaderView = wdtHeader

//        tableView.tableHeaderView = scrollView
//        headerView = tableView.tableHeaderView
//        tableView.tableHeaderView = nil
//        tableView.addSubview(headerView)
//        
//        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
//        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        
        
//        
//        
//        
//        self.view.backgroundColor = UIColor.greenColor()
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = header.bounds
//        let color3 = UIColor.clearColor().CGColor as CGColorRef
//        let color4 = UIColor(white: 0.0, alpha: 0.6).CGColor as CGColorRef
//        gradientLayer.colors = [color3, color4]
//        gradientLayer.locations = [0.2, 1.0]
//        header.layer.addSublayer(gradientLayer)
//        
//        
//        let firstName = UILabel(frame: CGRectZero)
//        header.addSubview(firstName)
//        firstName.font = UIFont.WDTAgoraRegular(16)
//        firstName.textColor = UIColor.whiteColor()
//        firstName.text = self.user["firstName"] as? String
//        firstName.snp_makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.bottom.equalTo(-20)
//        }
//        
//        self.tableView.tableHeaderView = header
//
        
        self.loadPosts()
    }
    
    func placeAvatars(scrollView: UIScrollView) {
        scrollView.subviews.forEach({
            $0.removeFromSuperview()
        })

        for (index, avatar) in avatars.enumerate() {
            let imageView = UIImageView(image: avatar)
            imageView.frame = CGRectMake(view.frame.width * CGFloat(index), 0, view.frame.width, self.headerHeight)
            print(imageView.frame)
            scrollView.addSubview(imageView)
        }
    }
    
    func updateHeaderView() {
        var headerRect = CGRectMake(0, -headerHeight, view.frame.width, headerHeight)
        
        if tableView.contentOffset.y < -headerHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        updateHeaderView()
//    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! WDTHeader
        headerView.scrollViewDidScroll(scrollView)
    }
    
    func editButtonTapped() {
        let destVC = EditVC()
        destVC.view.backgroundColor = UIColor.whiteColor()
        let nc = UINavigationController(rootViewController: destVC)
        self.presentViewController(nc, animated: true, completion: nil)
    }
    
    override func loadPosts() {
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.wdtPost.collectionOfAllPosts.count
    }
    
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = wdtPost.collectionOfAllPosts[indexPath.section]
        cell.viewController = self
        cell.moreBtn.tag = indexPath.section
        cell.moreBtn.addTarget(self, action: #selector(moreBtnTapped), forControlEvents: .TouchUpInside)
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
        let post = self.wdtPost.collectionOfAllPosts[section]
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
        let post = self.wdtPost.collectionOfAllPosts[section]
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
        let post = wdtPost.collectionOfPosts[button.tag]
        let user = post["user"] as! PFUser
        
        if button.selected == true {
            print("UnDown")
            button.selected = false
            WDTActivity.deleteActivity(user, post: post)
        } else {
            print("Downed")
            button.selected = true
            WDTActivity.addActivity(user, post: post, type: .Down, completion: { _ in })
            
        }
    }
    
    func replyBtnTapped(sender: AnyObject) {
        let destVC = ReplyViewController()
        let post = self.wdtPost.collectionOfAllPosts[sender.tag]
        destVC.toUser = post.objectForKey("user") as! PFUser
        destVC.usersPost = post
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func moreBtnTapped(sender: AnyObject) {
        let post = self.wdtPost.collectionOfAllPosts[sender.tag]
        let user = post["user"] as! PFUser
        let guest = MorePostsVC()
        guest.user = user
        guest.geoPoint = self.geoPoint
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
