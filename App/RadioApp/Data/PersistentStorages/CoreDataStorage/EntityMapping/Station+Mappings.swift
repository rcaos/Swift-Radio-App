//
//  Station+Mappings.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Domain
import Foundation
import CoreData

extension Station {
  
  static func insert(into context: NSManagedObjectContext, stationRemote: StationRemote) -> Station {
    let stationLocal: Station = context.insertObject()
    
    stationLocal.id = stationRemote.id
    stationLocal.name = stationRemote.name
    stationLocal.order = stationRemote.order
    stationLocal.city = stationRemote.city
    stationLocal.frecuency = stationRemote.frecuency
    stationLocal.slogan = stationRemote.slogan
    stationLocal.urlStream = stationRemote.urlStream
    stationLocal.image = stationRemote.pathImage
    stationLocal.isActive = stationRemote.isActive
    stationLocal.group = stationRemote.group
    stationLocal.groupId = stationRemote.groupId
    stationLocal.groupBase = stationRemote.groupBase
    return stationLocal
  }
}

extension StationRemote {
  
  init(stationLocal: Station) {
    self = .init(id: stationLocal.id,
                 name: stationLocal.name,
                 order: stationLocal.order,
                 city: stationLocal.city,
                 frecuency: stationLocal.frecuency,
                 slogan: stationLocal.slogan,
                 urlStream: stationLocal.urlStream,
                 pathImage: stationLocal.image,
                 group: stationLocal.group,
                 groupId: stationLocal.groupId,
                 groupBase: stationLocal.groupBase,
                 isActive: stationLocal.isActive
    )
  }
}
