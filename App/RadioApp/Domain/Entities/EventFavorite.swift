//
//  EventFavorite.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct EventFavorite {
  
  let statioName: String
  
  var asDictionary: [String: Any] {
    return [
      "station_name": statioName
    ]
  }
}
