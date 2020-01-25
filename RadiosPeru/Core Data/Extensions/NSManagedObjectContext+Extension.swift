//
//  NSManagedObjectContext+Extension.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import CoreData

//extension NSManagedObjectContext {
//    
//    func insertObject<A: NSManagedObject>() -> A where A:Managed {
//        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
//            fatalError("Wrong Object type")
//        }
//        return obj
//    }
//    
//    func performChanges(block: @escaping () -> Void) {
//        perform {
//            block()
//            _ = self.saveOrRollback()
//        }
//    }
//    
//    //MARK: - Private
//    
//    private func saveOrRollback() -> Bool {
//        do {
//            try save()
//            return true
//        } catch  {
//            rollback()
//            return false
//        }
//    }
//}
