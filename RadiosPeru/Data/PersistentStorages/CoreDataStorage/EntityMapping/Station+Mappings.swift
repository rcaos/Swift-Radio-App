//
//  Station+Mappings.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import CoreData

extension Station {
  
  static func insert(into context: NSManagedObjectContext, stationRemote: StationRemote) -> Station {
    let stationLocal: Station = context.insertObject()
    
    stationLocal.name = stationRemote.name
    stationLocal.city = stationRemote.city
    stationLocal.frecuency = stationRemote.frecuency
    stationLocal.slogan = stationRemote.slogan
    stationLocal.urlStream = stationRemote.urlStream
    stationLocal.image = stationRemote.pathImage
    stationLocal.group = stationRemote.group
    stationLocal.groupId = stationRemote.groupId
    stationLocal.groupBase = stationRemote.groupBase
    return stationLocal
  }
}

extension StationRemote {
  
  init(stationLocal: Station) {
    name = stationLocal.name
    city = stationLocal.city
    frecuency = stationLocal.frecuency
    slogan = stationLocal.slogan
    urlStream = stationLocal.urlStream
    pathImage = stationLocal.image
    
    group = stationLocal.group
    groupId = stationLocal.groupId
    groupBase = stationLocal.groupBase
  }
}
