//
//  StationFavoriteCD+PersistenceStore.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension PersistenceStore where Entity == StationFavoriteCD {
  
  func saveFavorite(_ simpleStation: SimpleStation, completion: @escaping (() -> Void)) {
    managedObjectContext.performChanges {
      _ = StationFavoriteCD.insert(into: self.managedObjectContext, stationFavorite: simpleStation)
      completion()
    }
  }
  
  func find(with station: SimpleStation) -> StationFavoriteCD? {
    let predicate = NSPredicate(format: "id == %i", station.id )
    return StationFavoriteCD.findOrFetch(in: managedObjectContext, matching: predicate)
  }
  
  func delete(with station: StationFavoriteCD, completion: @escaping (() -> Void)) {
    managedObjectContext.performChanges {
      self.managedObjectContext.delete(station)
      completion()
    }
  }
  
  func findAll() -> [StationFavoriteCD] {
    return StationFavoriteCD.fetch(in: managedObjectContext)
  }
}
