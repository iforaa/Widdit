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

  //what user we are sending the message to
  var toUser: String!

  override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
    return .Plain
  }

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
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


    //build our queries
    let toUser = PFQuery(className: "replies")
    toUser.whereKey("to", equalTo: (PFUser.currentUser()?.username)!)
    toUser.whereKey("by", equalTo: self.toUser)

    let byUser = PFQuery(className: "replies")
    byUser.whereKey("to", equalTo: self.toUser)
    byUser.whereKey("by", equalTo: (PFUser.currentUser()?.username)!)

    let query = PFQuery.orQueryWithSubqueries([toUser, byUser])

    query.addAscendingOrder("updatedAt")


    //querying...
    query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error) in
      if error == nil {
        self.messages.removeAll()
        for object in objects! {
          let message = MessageModel(name: (object.objectForKey("by") as! String), body: (object.objectForKey("body") as! String))
          let indexPath = NSIndexPath(forRow: 0, inSection: 0)
          self.tableView!.beginUpdates()
          self.messages.insert(message, atIndex: 0)
          self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
          self.tableView?.endUpdates()
        }
      } else {
        print("Error getting posts: \(error)")
      }
    }
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

    let message = MessageModel(name: "Ethan", body: self.textView.text)

    let parseMessage = PFObject(className: "replies")

    parseMessage["by"] = PFUser.currentUser()?.username
    parseMessage["to"] = toUser
    parseMessage["body"] = self.textView.text

    let indexPath = NSIndexPath(forRow: 0, inSection: 0)

    //sends message
    parseMessage.saveInBackgroundWithBlock { (bool, error) in
      if bool {
        print("Sent message")
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
