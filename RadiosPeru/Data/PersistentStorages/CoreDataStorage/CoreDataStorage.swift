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
    
    private lazy var persistentContainer: NSPersistentContainer = {
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
    
    // MARK: - Core Data Saving support
    
    // MARK: -  Cuando lo llama ???
    
    private func saveContext () {
        
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - StationsLocalStorage

extension CoreDataStorage: StationsLocalStorage {
    
    func saveStations(stations: [StationRemote], completion: @escaping (Result<Void, Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                //try strongSelf.cleanUpQueries(for: query, inContext: context)
                
                // Station es la entitie del .xcdatamodeld
                
                let _ = stations.map({
                    Station(stationRemote: $0, insertInto: strongSelf.mainContext)
                })
                
                try strongSelf.mainContext.save()
                
                DispatchQueue.global(qos: .background).async {
                    completion( .success( () ) )
                }
            } catch {
                
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.writeError(error)))
                }
                print(error)
            }
        }
    }
    
    func stationsList(completion: @escaping (Result<[StationRemote], Error>) -> Void) {
        
        // Los SortDescriptors los puedo tener en una clase aparte.
        
        persistentContainer.performBackgroundTask { [weak self] _ in
        guard let strongSelf = self else { return }
            
            do {
                let request: NSFetchRequest<Station> = Station.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Station.name),
                                                            ascending: false)]
                //request.fetchLimit = number
                
                // LLama al otro constructor
                let resut = try strongSelf.mainContext.fetch(request).map ( StationRemote.init )
                DispatchQueue.global(qos: .background).async {
                    completion(.success(resut))
                }
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.readError(error)))
                }
                print(error)
            }
        }
    }
    
    // MARK: - En el method save .
    //fileprivate func cleanUpQueries(for query: MovieQuery, inContext context: NSManagedObjectContext) throws { }
    
}
