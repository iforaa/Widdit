//
//  Message.swift
//  Widdit
//
//  Created by Ethan Thomas on 4/20/16.
//  Copyright © 2016 John McCants. All rights reserved.
//

import UIKit

struct MessageModel {
  var name: String
  var body: String

  init(name: String, body: String) {
    self.name = name
    self.body = body
  }
}
