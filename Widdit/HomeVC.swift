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


class HomeVC: UICollectionViewController {
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 10
    var uuidArray = [String]()
    var postsArray = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        self.collectionView?.backgroundColor = UIColor .whiteColor()
        self.collectionView?.alwaysBounceVertical = true
        
        // Title at the top
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(refresher)
        
        self.collectionView?.reloadData()
        
        //load Posts
//        loadPosts()
        


    }
    
    override func viewWillAppear(animated: Bool) {
        self.viewDidLoad()
    }
    
    
    // refresh func
    func refresh() {
        
        // Reload Data Information
//        loadPosts()
        refresher.endRefreshing()
    }
    
    // load func
//    func loadPosts() {
//        
//        let query = PFQuery(className: "posts")
//        query.whereKey("username", equalTo: (PFUser.currentUser()?.username!)!)
//        query.limit = page
//        query.findObjectsInBackgroundWithBlock ({ (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                
//                // clean up
//                self.uuidArray.removeAll(keepCapacity: false)
//                self.postsArray.removeAll(keepCapacity: false)
//                
//                
//                // find objects related to our query
//                for object in objects! {
//                    
//                    // Add found data to our arrays
//                    self.uuidArray.append(object.valueForKey("uuid") as! String)
//                    self.postsArray.append(object.valueForKey("pic") as! PFFile)
//                }
//                
//                self.collectionView?.reloadData()
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//    }
    
    
    @IBAction func logout(sender: AnyObject) {
        
        // implement log out
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            if error == nil {
                
                // remove logged in user from App memory
                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                NSUserDefaults.standardUserDefaults().synchronize()

                FBSDKLoginManager().logOut()
                PFUser.logOut()

                let cookie: NSHTTPCookie?
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    
    



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostCell
    
        // Configure the cell
    
        return cell
    }
    
    // header config
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! HeaderView
        
        
        header.firstNameLbl.text = (PFUser.currentUser()?.objectForKey("firstName") as? String)?.uppercaseString
        header.bioLbl.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.bioLbl.sizeToFit()
        header.userName.text = PFUser.currentUser()?.objectForKey("username") as? String
        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            header.avaImg.image = UIImage(data: data!)
        }
        header.editProfileBtn.setTitle("edit profile", forState: .Normal)
        
        
        
        return header
        
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
