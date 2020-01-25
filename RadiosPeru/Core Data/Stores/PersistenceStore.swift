//
//  PersistenceStore.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

//protocol PersistenceStoreDelegate: class {
//    
//    func persistenceStore(didUpdateEntity update: Bool)
//    
//}
//
//class PersistenceStore<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
//    
//    var managedObjectContext: NSManagedObjectContext
//    
//    private var fetchedResultsController: NSFetchedResultsController<Entity>!
//    private var changeTypes: [NSFetchedResultsChangeType]!
//    
//    weak var delegate: PersistenceStoreDelegate?
//    
//    var entities: [Entity] {
//        return fetchedResultsController.fetchedObjects ?? []
//    }
//    
//    //MARK: - Initializers
//    
//    init(_ managedObjectContext: NSManagedObjectContext) {
//        self.managedObjectContext = managedObjectContext
//        super.init()
//    }
//    
//    //MARK: - Public
//    
//    func configureResultsController(batchSize: Int = 5, limit: Int = 0,
//                                    sortDescriptors: [NSSortDescriptor] = [],
//                                    predicate: NSPredicate? = nil,
//                                    notifyChangesOn changeTypes: [NSFetchedResultsChangeType] = [.insert, .delete, .move, .update]) {
//        guard let entityName = Entity.entity().name else { fatalError() }
//        
//        let request = NSFetchRequest<Entity>(entityName: entityName)
//        request.fetchBatchSize = batchSize
//        request.fetchLimit = limit
//        request.predicate = predicate
//        request.sortDescriptors = sortDescriptors
//        request.returnsObjectsAsFaults = false
//        
//        self.changeTypes = changeTypes
//        
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        
//        fetchedResultsController.delegate = self
//        
//        performFetch()
//    }
//    
//    private func performFetch() {
//        do {
//            try fetchedResultsController.performFetch()
//        } catch  {
//            fatalError( error.localizedDescription)
//        }
//    }
//    
//    //MARK: - NSFetchedResultsControllerDelegate
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//        guard changeTypes.contains(type) else { return }
//        
//        if anObject as? Entity != nil {
//            delegate?.persistenceStore(didUpdateEntity: true)
//        }
//    }
//    
//}
