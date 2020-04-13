//
//  CoreDataStorage+FavoritesLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension CoreDataStorage: FavoritesLocalStorage {
  
  func configStore() {
    storeFavorites = PersistenceStore(mainContext)
    storeFavorites?.configureResultsController()
    storeFavorites?.delegate = self
  }
  
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
        
        if fetched != nil {
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

// MARK: - PersistenceStoreDelegate

extension CoreDataStorage: PersistenceStoreDelegate {
  
  func persistenceStore(didUpdateEntity update: Bool) {
    delegate?.favoritesLocalStorage(didUpdateEntity: update)
  }
}
