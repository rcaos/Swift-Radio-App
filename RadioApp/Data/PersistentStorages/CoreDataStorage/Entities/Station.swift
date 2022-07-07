//
//  Station.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class Station: NSManagedObject {
  
  @NSManaged var id: Int
  @NSManaged var name: String
  @NSManaged var order: Int
  @NSManaged var image: String
  @NSManaged var city: String
  @NSManaged var frecuency: String
  @NSManaged var slogan: String
  @NSManaged var urlStream: String
  @NSManaged var isActive: Bool
  
  @NSManaged var group: String
  @NSManaged var groupId: String
  @NSManaged var groupBase: String
}

extension Station {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
    return NSFetchRequest<Station>(entityName: "Station")
  }
}

// MARK: - Managed

extension Station: Managed {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(name), ascending: true)]
  }
  
}
