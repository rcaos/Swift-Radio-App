//
//  Station+PersistenceStore.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension PersistenceStore where Entity == Station {
  
  func saveStation(_ stationRemote: StationRemote, completion: @escaping (() -> Void)) {
      managedObjectContext.performChanges {
          _ = Station.insert(into: self.managedObjectContext, stationRemote: stationRemote)
          completion()
      }
  }
  
  func findAll() -> [Station] {
    return Station.fetch(in: managedObjectContext)
  }
}
