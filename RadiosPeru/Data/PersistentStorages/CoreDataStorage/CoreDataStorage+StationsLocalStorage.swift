//
//  CoreDataStorage+StationsLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData
import RxSwift

extension CoreDataStorage: StationsLocalStorage {
  
  func saveStations(stations: [StationRemote]) -> Observable<Void> {
    
    for station in stations {
      mainContext.performChanges { [weak self] in
        guard let strongSelf = self else { return }
        _ = Station.insert(into: strongSelf.mainContext, stationRemote: station)
      }
    }
    return Observable.just(())
  }
  
  func stationsList() -> Observable<[StationRemote]> {
    
    do {
      let entities = try fetchStations(inContext: mainContext)
      
      let result = entities.map( StationRemote.init )
      
      return Observable.just(result)
      
    } catch {
      print(error)
      return Observable.error( CoreDataStorageError.readError(error) )
    }
  }
  
  func findStations(with stations: [SimpleStation]) -> Observable<[StationRemote]> {
    
    do {
      let localEntities = try fetchStations(inContext: mainContext)
      
      var filterEntities: [StationRemote] = []
      
      stations.forEach({ favorite in
        if let found = localEntities.first(where: { $0.name == favorite.name }) {
          filterEntities.append( StationRemote(stationLocal: found) )
        }
      })
      return Observable.just(filterEntities)
      
    } catch {
      print(error)
      return Observable.error( CoreDataStorageError.readError(error) )
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
