//
//  CoreDataStorage+FavoritesLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData
import RxSwift

extension CoreDataStorage: FavoritesLocalStorage {
  
  func configStore() {
    storeFavorites = PersistenceStore(mainContext)
    storeFavorites?.configureResultsController()
    storeFavorites?.delegate = self
  }
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool> {
    
    do {
      let fetched = try find(for: station, inContext: mainContext)
      
      if let exist = fetched {
        mainContext.delete(exist)
        return Observable.just(false)
      } else {
        _ = StationFavoriteCD.insert(into: mainContext, stationFavorite: station)
        try mainContext.save()
        return Observable.just(true)
      }
    } catch {
      print(error)
      return Observable.error( CoreDataStorageError.writeError(error) )
    }
  }
  
  func favoritesList() -> Observable<[SimpleStation]> {
    
    do {
      let entities = try fetchFavorites(inContext: mainContext)
      let result = entities.map( SimpleStation.init )
      
      return Observable.just(result)
    } catch {
      print(error)
      return Observable.error( CoreDataStorageError.readError(error) )
    }
  }
  
  func isFavorite(station: SimpleStation) -> Observable<Bool> {
    
    do {
      let fetched = try find(for: station, inContext: mainContext)
      
      if fetched != nil {
        return Observable.just(true)
      } else {
        return Observable.just(false)
      }
      
    } catch {
      print(error)
      return Observable.error(CoreDataStorageError.readError(error))
    }
  }
  
  fileprivate func find(for station: SimpleStation, inContext context: NSManagedObjectContext) throws -> StationFavoriteCD? {
    
    let entities = try fetchFavorites(inContext: context)
    
    let filter = entities.filter { $0.name == station.name }
    
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
