//
//  NSManagedObjectContext+Extensions.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
  
  func insertObject<A: NSManagedObject>() -> A where A: Managed {
    guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
      fatalError("Wrong object type")
    }
    return obj
  }
  
  func saveOrRollback() -> Bool {
    do {
      try save()
      return true
    } catch {
      rollback()
      return false
    }
  }
  
  func performChanges(block: @escaping () -> Void) {
    perform {
      block()
      _ = self.saveOrRollback()
    }
  }
  
}
