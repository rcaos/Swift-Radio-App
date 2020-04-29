//
//  Event.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct Event {
  
  let radioId: Int
  let radioName: String
  let urlStream: String
  let description: String
  let date: Date
  
  var uuid: String?
}
