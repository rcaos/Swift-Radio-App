//
//  StationFavoriteCD+Mappings.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension StationFavoriteCD {
  
  static func insert(into context: NSManagedObjectContext, stationFavorite: SimpleStation) -> StationFavoriteCD {
    let favoriteLocal: StationFavoriteCD = context.insertObject()
    
    favoriteLocal.createAt = Date()
    favoriteLocal.name = stationFavorite.name
    favoriteLocal.group = stationFavorite.group
    return favoriteLocal
  }
}

extension SimpleStation {
  
  init(stationLocal: StationFavoriteCD) {
    name = stationLocal.name
    group = stationLocal.group
  }
}
