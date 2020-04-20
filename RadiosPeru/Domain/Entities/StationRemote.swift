//
//  StationRemote.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

struct StationRemote {
  
  let name: String
  let city: String
  let frecuency: String
  let slogan: String
  let urlStream: String
  let pathImage: String
  
  let group: String
  let groupId: String
  let groupBase: String
}

extension StationRemote {
  
  var type: Group {
    if group == "rpp" {
      return .rpp( RPP(type: self.group, id: self.groupId) )
    } else {  //"crp"
      return .crp( CRP(type: self.group, base: self.groupBase) )
    }
  }
}

extension StationRemote: Equatable {
  
}
