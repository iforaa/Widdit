//
//  GuestVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse


var guestName = [String]()
var usernameArray = [String]()
var avaArray = [PFFile]()
var dateArray = [NSDate?]()
var picArray = [PFFile]()
var titleArray = [String]()
var uuidArray = [String]()
var postuuid = [String]()

class GuestVC: UICollectionViewController {
    
    // UI Objects
    var refresher : UIRefreshControl!
    var page : Int = 12

    // Arrays to hold data from server
    var uuidArray = [String]()
    var postTxtArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow Vertical Scroll
        self.collectionView?.alwaysBounceVertical = true
        
        // Background Color
        self.collectionView?.backgroundColor = UIColor .whiteColor()
        
        // Top Title
        self.navigationItem.title = guestName.last?.uppercaseString
        
//        // New Back Button
//        self.navigationItem.hidesBackButton = true
//        let backBtn = UIBarButtonItem(image: UIImage(named: "backbutton"), style: .Plain, target: self, action: "back:")
//        self.navigationItem.leftBarButtonItem = backBtn
        
        // Swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        // Pull to Refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        

    }

    func back(sender: UIBarButtonItem) {
        
        // Push Back
        self.navigationController?.popViewControllerAnimated(true)
        
        // Clean Guest Username or deduct the last guest username from guestName = Array
        if !guestName.isEmpty {
            guestName.removeLast()
        }
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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return usernameArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        
        
        
        // Connect objects with our information from arrays
        cell.userNameBtn.setTitle(usernameArray[indexPath.row], forState: .Normal)
        cell.userNameBtn.sizeToFit()
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.postText.text = postTxtArray[indexPath.row]
        cell.postText.sizeToFit()
        
        
        // Place Profile Picture
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            cell.avaImage.image = UIImage(data: data!)
            
        }
        
        // Calculate Post Time
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
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
        
        return cell
    }
    
    // header config
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
        
    }

}
