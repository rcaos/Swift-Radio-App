//
//  StationRemote.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public struct StationRemote {
  
  let id: Int
  let name: String
  let order: Int
  let city: String
  let frecuency: String
  let slogan: String
  let urlStream: String
  let pathImage: String
  
  let group: String
  let groupId: String
  let groupBase: String
  
  let isActive: Bool
}

extension StationRemote {
  
  var type: Group {
    if group == "rpp" {
      return .rpp( RPP(type: self.group, id: self.groupId) )
    } else if group == "crp" {
      return .crp( CRP(type: self.group, base: self.groupBase) )
    } else {
      return .unknown
    }
  }
}

extension StationRemote: Equatable {
  
}

public struct StationProp {
  
  let id: Int
  let name: String
  let city: String
  let frecuency: String
  let slogan: String
  let urlStream: String
  let pathImage: String
  let type: Group
  
  init(station: StationRemote) {
    id = station.id
    name = station.name
    city = station.city
    frecuency = station.frecuency
    slogan = station.slogan
    urlStream = station.urlStream
    pathImage = station.pathImage
    type = station.type
  }
}
