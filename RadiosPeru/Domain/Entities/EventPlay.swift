//
//  EventPlay.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct EventPlay {
  
  var stationName: String
  
  var start: Date
  
  var end: Date
  
  var seconds: Int {
    return Int(end.timeIntervalSince(start))
  }
  
  static var empty: EventPlay {
    return EventPlay(stationName: "", start: Date(), end: Date())
  }
  
  var asDictionary: [String: Any] {
    return [
      "station_name": stationName,
      "seconds": seconds
    ]
  }
}
