//
//  ActivityVC.swift
//  Widdit
//
//  Created by John McCants on 3/19/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse


class ActivityVC: UICollectionViewController {
    
    // arrays to hold data from server
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var typeArray = [String]()
    var dateArray = [NSDate?]()
    var uuidArray = [String]()
    var ownerArray = [String]()
    var postTextArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dynamic collectionView height - dynamic cell
        collectionView?.backgroundColor = UIColor .whiteColor()
        
        // title at the top
        self.navigationItem.title = "Activity"
        
        // request notifications
        let query = PFQuery(className: "Activity")
        query.whereKey("to", equalTo: PFUser.currentUser()!.username!)
        query.limit = 30
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepCapacity: false)
                self.avaArray.removeAll(keepCapacity: false)
                self.typeArray.removeAll(keepCapacity: false)
                self.dateArray.removeAll(keepCapacity: false)
                self.uuidArray.removeAll(keepCapacity: false)
                self.ownerArray.removeAll(keepCapacity: false)
                self.postTextArray.removeAll(keepCapacity: false)
                
                // found related objects
                for object in objects! {
                    
                    self.usernameArray.append(object.objectForKey("by") as! String)
                    self.avaArray.append(object.objectForKey("ava") as! PFFile)
                    self.typeArray.append(object.objectForKey("type") as! String)
                    self.dateArray.append(object.createdAt)
                    self.uuidArray.append(object.objectForKey("uuid") as! String)
                    self.ownerArray.append(object.objectForKey("owner") as! String)
                    self.postTextArray.append(object.objectForKey("postText") as! String)
                    
                    
                    // save notifcations as checked
                    object["checked"] = "yes"
                    object.saveEventually()
                    
                }
                
                // reload CollectionView to show received data
                self.collectionView?.reloadData()
                
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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return usernameArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ActivityCell
        
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], forState: .Normal)
        cell.usernameBtn.titleLabel?.text = usernameArray[indexPath.row]
        cell.infoLbl.text = "is down for your post"
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        cell.postText.text = postTextArray[indexPath.row]
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second > 0 && difference.minute == 0 {
            cell.dateLbl.text = "\(difference.second)s."
        }
        if difference.minute > 0 && difference.hour == 0 {
            cell.dateLbl.text = "\(difference.minute)m."
        }
        if difference.hour > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h."
        }
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.dateLbl.text = "\(difference.day)d."
        }
        if difference.weekOfMonth > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w."
        }
 
        
        // define info text
        if typeArray[indexPath.row] == "down" {
            cell.infoLbl.text = "is down for your post"
        }
        
        // Asign index of button
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
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
