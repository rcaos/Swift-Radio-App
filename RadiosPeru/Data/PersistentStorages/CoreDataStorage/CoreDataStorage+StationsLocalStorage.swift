//
//  CoreDataStorage+StationsLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

extension CoreDataStorage: StationsLocalStorage {
  
  func saveStations(stations: [StationRemote], completion: @escaping (Result<Void, Error>) -> Void) {
    
    persistentContainer.performBackgroundTask { [weak self] _ in
      guard let strongSelf = self else { return }
      
      do {
        
        for station in stations {
          let _ = Station(stationRemote: station, insertInto: strongSelf.mainContext)
        }
        try strongSelf.mainContext.save()
        
        DispatchQueue.global(qos: .background).async {
          completion( .success( () ) )
        }
      } catch {
        print("error CoreDataStorage: [\(error)]")
        
        DispatchQueue.global(qos: .background).async {
          completion(.failure(CoreDataStorageError.writeError(error)))
        }
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
