//
//  UserMorePostsViewController.swift
//  Widdit
//
//  Created by Ethan Thomas on 5/1/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit
import Parse

class UserMorePostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!

    var currentUser: String?
    var userPosts = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        print(currentUser)

        title = "\(currentUser!)'s posts"

        //query for user's posts
        let userQuery = PFQuery(className: "posts")
        userQuery.whereKey("username", equalTo: currentUser!)
        userQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err) in
            if err == nil {
                for object in objects! {
                    self.userPosts.append(object)
                }
                self.collectionView.reloadData()
            } else {
                print("Error getting user's posts: \(err)")
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        let post = self.userPosts[indexPath.row] as! PFObject
        let avaObject = post.objectForKey("ava") as! PFFile
        avaObject.getDataInBackgroundWithBlock { (data, err) in
            if err == nil {
                cell.avaImage.image = UIImage(data: data!)
            } else {
                print("Error getting user avatar: \(err)")
            }
        }
        cell.userNameBtn.setTitle(post.objectForKey("username") as! String, forState: .Normal)
        cell.morePostsButton.hidden = true
        cell.replyBtn.hidden = true
        cell.imDownBtn.hidden = true

        cell.firstNameLbl.text = String(post.objectForKey("firstName")!)

        cell.postText.text = post.objectForKey("postText") as! String


        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor .blackColor().CGColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true


        // manipulate down button depending on did user like it or not
//        let didDown = PFQuery(className: "downs")
//        didDown.whereKey("by", equalTo: PFUser.currentUser()!.username!)
//        didDown.whereKey("to", equalTo: cell.uuidLbl.text!)
//        didDown.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
//            // if no any likes are found, else found likes
//            if count == 0 {
//                cell.imDownBtn.setTitle("I'm Down", forState: .Normal)
//            } else {
//                cell.imDownBtn.setTitle("Undown", forState: .Normal)
//            }
//        }

        // Place Profile Picture
//        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
//            cell.avaImage.image = UIImage(data: data!)
//        }


//        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
//
//        cell.morePostsButton.layer.setValue(indexPath, forKey: "index")
//
//        cell.replyBtn.layer.setValue(indexPath.row, forKey: "index")
//
//        // Calculate Post Date
//        let from = dateArray[indexPath.row]
//        let now = NSDate()
//        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
//        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
//
//        // Logic what to show: seconds, minutes, hours, days or weeks
//        if difference.second <= 0 {
//            cell.timeLbl.text = "now"
//        }
//        if difference.second > 0 && difference.minute == 0 {
//            cell.timeLbl.text = "\(difference.second)s."
//        }
//        if difference.minute > 0 && difference.hour == 0 {
//            cell.timeLbl.text = "\(difference.minute)m."
//        }
//        if difference.hour > 0 && difference.day == 0 {
//            cell.timeLbl.text = "\(difference.hour)h."
//        }
//        if difference.day > 0 && difference.weekOfMonth == 0 {
//            cell.timeLbl.text = "\(difference.day)d."
//        }
//        if difference.weekOfMonth > 0 {
//            cell.timeLbl.text = "\(difference.weekOfMonth)w."
//        }


        return cell
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
