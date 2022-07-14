//
//  StationFavorite.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class StationFavoriteCD: NSManagedObject {
  
  @NSManaged var createAt: Date
  @NSManaged var id: Int
  @NSManaged var name: String
}

extension StationFavoriteCD {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<StationFavoriteCD> {
    return NSFetchRequest<StationFavoriteCD>(entityName: "StationFavoriteCD")
  }
}

// MARK: - Managed

extension StationFavoriteCD: Managed {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(createAt), ascending: false )]
  }
  
}
