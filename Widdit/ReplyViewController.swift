//
//  ViewController.swift
//  IPMQuickstart
//
//  Created by Brent Schooley on 12/8/15.
//  Copyright © 2015 Twilio. All rights reserved.
//

import UIKit
import SlackTextViewController
import Parse

class ReplyViewController: SLKTextViewController {
  //list of messages
  var messages = [MessageModel]()
    var usersPost: PFObject!

    var userObjArray = [PFObject]()

  //what user we are sending the message to
  var toUser: String!

  override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
    return .Plain
  }

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print(self.toUser)
    print(usersPost)

    
    // Associate the device with a user
    let installation = PFInstallation.currentInstallation()
    installation["user"] = PFUser.currentUser()
    installation.saveInBackground()

    let userQuery = PFQuery(className: "_User")

    userQuery.whereKey("username", equalTo: toUser)

    userQuery.findObjectsInBackgroundWithBlock { (users: [PFObject]?, err) in
        if err == nil {
            print(users)
            let replyQuery = PFQuery(className: "replies")
            let recipient = users?.first as! PFUser
            
            replyQuery.includeKey("sender")
            replyQuery.whereKey("recipient", equalTo: recipient)
            replyQuery.addDescendingOrder("createdAt")
            
            
            replyQuery.findObjectsInBackgroundWithBlock({ (replies: [PFObject]?, err) in
                if err == nil {
                    if replies?.count > 0 {
                        self.messages = replies!.map({ (reply) -> MessageModel in
                            
                            var message = MessageModel(name: "", body: "")
                            
                            let sender = reply["sender"] as! PFUser

                            if let firstName = sender["firstName"]  {
                                message.name = firstName as! String
                            } else {
                                message.name = "No name"
                            }
                            
                            if let body = reply["body"] {
                                message.body = body as! String
                            }
                            
                            return message
                        })
                        
                        self.tableView?.reloadData()
                    } else {
                        print("No objects")
                    }
                } else {
                    print(err)
                }
            })
        } else {
            print(err)
        }
    }


    self.tableView!.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
//    print(toUser)
    self.inverted = false
    self.tableView!.rowHeight = UITableViewAutomaticDimension
    self.tableView!.estimatedRowHeight = 64.0
    self.tableView!.separatorStyle = .None
    self.registerPrefixesForAutoCompletion(["@",  "#", ":", "+:", "/"])

    self.textView.placeholder = "Message";

    self.textView.registerMarkdownFormattingSymbol("*", withTitle: "Bold")
    self.textView.registerMarkdownFormattingSymbol("_", withTitle: "Italics")
    self.textView.registerMarkdownFormattingSymbol("~", withTitle: "Strike")
    self.textView.registerMarkdownFormattingSymbol("`", withTitle: "Code")
    self.textView.registerMarkdownFormattingSymbol("```", withTitle: "Preformatted")
    self.textView.registerMarkdownFormattingSymbol(">", withTitle: "Quote")
  }

  // MARK: UITableView Delegate
  // Return number of rows in the table
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messages.count
  }

  // Create table view rows
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
      let cell = self.tableView!.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
      let message = self.messages[indexPath.row]

      // Set table cell values
      cell.nameLabel.text = message.name
      cell.bodyLabel.text = message.body
      cell.selectionStyle = .None

      return cell
  }

  // MARK: UITableViewDataSource Delegate
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
}

extension ReplyViewController {
  override func didPressRightButton(sender: AnyObject?) {
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    self.textView.refreshFirstResponder()

    let message = MessageModel(name: PFUser.currentUser()!.username!, body: self.textView.text)

    let parseMessage = PFObject(className: "replies")

    parseMessage["sender"] = PFUser.currentUser()

    let recipientQuery = PFQuery(className: "_User")

    recipientQuery.whereKey("username", equalTo: toUser)

    recipientQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, err) in
        if err == nil {
            if objects?.count > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    let pointer = objects?.first
                    parseMessage["recipient"] = pointer
                    parseMessage.saveInBackground()
                })
            } else {
                print("No objects")
            }
        } else {
            print(err)
        }
    }


    parseMessage["body"] = self.textView.text

    let userQuery = PFUser.query()
    userQuery?.whereKey("username", equalTo: toUser)

    let pushQuery = PFInstallation.query()
    pushQuery?.whereKey("user", matchesQuery: userQuery!)

    let push = PFPush()
    let data = ["alert": "New message from \(PFUser.currentUser()!.username!): \(self.textView.text)", "badge": "Increment", "sound": "notification.mp3"]
    push.setData(data)
    push.setQuery(pushQuery)
    push.sendPushInBackground()
    

    let indexPath = NSIndexPath(forRow: 0, inSection: 0)

    parseMessage["post"] = PFObject(withoutDataWithClassName: "posts", objectId: self.usersPost.objectId)

    //sends message
    parseMessage.saveInBackgroundWithBlock { (bool, error) in
      if bool {
        print("Sent message")
        print(parseMessage)
        let rowAnimation: UITableViewRowAnimation = self.inverted ? .Bottom : .Top
        let scrollPosition: UITableViewScrollPosition = self.inverted ? .Bottom : .Top
        self.tableView!.beginUpdates()
        self.messages.insert(message, atIndex: 0)
        self.tableView!.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
        self.tableView!.endUpdates()
        self.tableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
        // Fixes the cell from blinking (because of the transform, when using translucent cells)
        // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
        self.tableView!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        super.didPressRightButton(sender)
      } else {
        print("Error sending message: \(error)")
      }
    }
  }
}
