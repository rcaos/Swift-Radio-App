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
                try stations.forEach({
                    let _ = Station(stationRemote: $0, insertInto: strongSelf.mainContext)
                    try strongSelf.mainContext.save()
                })
                
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
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                let entities = try strongSelf.fetchStations(inContext: strongSelf.mainContext)

                let result = entities.map( StationRemote.init )
                
                DispatchQueue.global(qos: .background).async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.readError(error)))
                }
                print(error)
            }
        }
    }
    
    func findStations(with stations: [SimpleStation], completion: @escaping (Result<[StationRemote], Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                
                let localEntities = try strongSelf.fetchStations(inContext: strongSelf.mainContext)
                
                var filterEntities: [StationRemote] = []
                
                stations.forEach({ favorite in
                    if let found = localEntities.first(where: { $0.name == favorite.name }) {
                        filterEntities.append( StationRemote(stationLocal: found) )
                    }
                })
                
                DispatchQueue.global(qos: .background).async {
                    completion(.success(filterEntities))
                }
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.readError(error)))
                }
                print(error)
            }
        }
    }
    
    fileprivate func fetchStations(inContext context: NSManagedObjectContext) throws -> [Station] {
        let request: NSFetchRequest<Station> = Station.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Station.name),
                                                    ascending: false)]
        //request.fetchLimit = number
        
        return try context.fetch(request)
    }
}

// MARK: - FavoritesLocalStorage

extension CoreDataStorage: FavoritesLocalStorage {
    
    func toogleFavorite(station: SimpleStation, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                let fetched = try strongSelf.find(for: station, inContext: strongSelf.mainContext)
                
                if let exist = fetched {
                    strongSelf.mainContext.delete(exist)
                    
                    completion( .success(false) )
                    
                } else {
                    let _ = StationFavoriteCD(stationFavorite: station, insertInto: strongSelf.mainContext)
                    
                    try strongSelf.mainContext.save()
                    
                    DispatchQueue.global(qos: .background).async {
                        completion( .success( (true) ) )
                    }
                }
            } catch {
                
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.writeError(error)))
                }
                print(error)
            }
        }
    }
    
    func favoritesList(completion: @escaping (Result<[SimpleStation], Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                let entities = try strongSelf.fetchFavorites(inContext: strongSelf.mainContext)
                let result = entities.map( SimpleStation.init )
                
                DispatchQueue.global(qos: .background).async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.readError(error)))
                }
                print(error)
            }
        }
    }
    
    func isFavorite(station: SimpleStation, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                let fetched = try strongSelf.find(for: station, inContext: strongSelf.mainContext)
                
                if let _ = fetched {
                    //let favorite = SimpleStation(stationLocal: entitie)
                    DispatchQueue.global(qos: .background).async {
                        completion(.success(true))
                    }
                } else {
                    DispatchQueue.global(qos: .background).async {
                        completion(.success(false) )
                    }
                }
                
            } catch {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataStorageError.readError(error)))
                }
                print(error)
            }
        }
    }
    
    fileprivate func find(for station: SimpleStation, inContext context: NSManagedObjectContext) throws -> StationFavoriteCD? {
        
        let entities = try fetchFavorites(inContext: context)
        
        let filter = entities.filter({ $0.name == station.name })
        
        return filter.first
    }
    
    fileprivate func fetchFavorites(inContext context: NSManagedObjectContext) throws -> [StationFavoriteCD] {
        let request: NSFetchRequest<StationFavoriteCD> = StationFavoriteCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(StationFavoriteCD.createAt),
                                                    ascending: false)]
        //request.fetchLimit = number
        
        return try context.fetch(request)
    }
    
}
