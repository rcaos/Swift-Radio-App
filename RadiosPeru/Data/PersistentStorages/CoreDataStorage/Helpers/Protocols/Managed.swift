//
//  Managed.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

protocol Managed: class, NSFetchRequestResult {
  
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
  
}

extension Managed {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return []
  }
  
  static var sortedFetchRequest: NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: entityName)
    request.sortDescriptors = defaultSortDescriptors
    return request
  }
  
}

extension Managed where Self: NSManagedObject {
  
  static var entityName: String {
    return entity().name!
  }
}
