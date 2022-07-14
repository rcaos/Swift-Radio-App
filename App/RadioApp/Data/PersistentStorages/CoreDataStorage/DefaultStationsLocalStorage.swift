//
//  DefaultStationsLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import CoreData

final class DefaultStationsLocalStorage: StationsLocalStorage {
  
  private let coreDataStack: CoreDataStorage
  private let store: PersistenceStore<Station>
  
  init(coreDataStack: CoreDataStorage) {
    self.coreDataStack = coreDataStack
    self.store = PersistenceStore(self.coreDataStack.mainContext)
    self.store.configureResultsController(sortDescriptors: Station.defaultSortDescriptors)
  }
  
  func saveStations(stations: [StationRemote]) -> Observable<Void> {
    
    return Observable<()>.create { [unowned self] (event) -> Disposable in
      let disposable = Disposables.create()
      
      if stations.isEmpty {
        event.onCompleted()
      }
      
      for (index, station) in stations.enumerated() {
        if index == stations.count - 1 {
          self.store.saveStation(station) {
            event.onCompleted()
          }
        } else {
          self.store.saveStation(station) { }
        }
      }
      return disposable
    }
  }
  
  func stationsList() -> Observable<[StationRemote]> {
    let remoteStations = store.findAll().map( StationRemote.init )
    return Observable.just(remoteStations)
  }
  
  func findStations(with stations: [SimpleStation]) -> Observable<[StationRemote]> {
    
    let localEntities = store.findAll()
    var filterEntities: [StationRemote] = []
    
    stations.forEach { favorite in
      if let found = localEntities.first(where: { $0.name == favorite.name }) {
        filterEntities.append( StationRemote(stationLocal: found) )
      }
    }
    return Observable.just(filterEntities)
  }
}
