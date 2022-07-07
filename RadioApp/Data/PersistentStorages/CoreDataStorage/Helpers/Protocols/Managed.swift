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
  
  static func fetch(in context: NSManagedObjectContext,
                    with sortDescriptors: [NSSortDescriptor] = defaultSortDescriptors,
                    configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    request.sortDescriptors = sortDescriptors
    configurationBlock(request)
    return (try? context.fetch(request)) ?? []
  }
  
  static func count(in context: NSManagedObjectContext,
                    configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> Int {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    configurationBlock(request)
    return (try? context.count(for: request)) ?? 0
  }
  
  static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
    return fetch(in: context) { request in
      request.predicate = predicate
      request.returnsObjectsAsFaults = false
      request.fetchLimit = 1
    }.first
  }
}
