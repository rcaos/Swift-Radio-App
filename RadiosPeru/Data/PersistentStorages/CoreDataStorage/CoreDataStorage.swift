//
//  CoreDataStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStorageError: Error {
  case readError(Error)
  case writeError(Error)
  case deleteError(Error)
}

final class CoreDataStorage {
  
  private let maxStorageLimit: Int
  
  init(maxStorageLimit: Int) {
    self.maxStorageLimit = maxStorageLimit
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "RadiosPeru")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  var mainContext: NSManagedObjectContext {
    let context = persistentContainer.viewContext
    context.mergePolicy = NSMergePolicy.overwrite
    return context
  }
}
