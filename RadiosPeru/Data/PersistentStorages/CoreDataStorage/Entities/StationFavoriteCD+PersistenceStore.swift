//
//  StationFavoriteCD+PersistenceStore.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension PersistenceStore where Entity == StationFavoriteCD {
  
  func saveFavorite(_ simpleStation: SimpleStation, completion: ((Bool) -> Void)? = nil) {
      managedObjectContext.performChanges {
          _ = StationFavoriteCD.insert(into: self.managedObjectContext, stationFavorite: simpleStation)
          completion?(true)
      }
  }
  
  func find(with station: SimpleStation) -> StationFavoriteCD? {
    let predicate = NSPredicate(format: "name == %@", station.name )
    return StationFavoriteCD.findOrFetch(in: managedObjectContext, matching: predicate)
  }
  
  func delete(with station: StationFavoriteCD, completion: ((Bool) -> Void)? = nil) {
    managedObjectContext.performChanges {
      self.managedObjectContext.delete(station)
      completion?(true)
    }
  }
  
  func findAll() -> [StationFavoriteCD] {
    return StationFavoriteCD.fetch(in: managedObjectContext)
  }
}
