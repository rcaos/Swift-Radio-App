//
//  DefaultFavoritesLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultFavoritesLocalStorage: FavoritesLocalStorage {
  
  private let coreDataStack: CoreDataStorage
  private let store: PersistenceStore<StationFavoriteCD>
  
  private let favoriteListSubject = BehaviorSubject<[SimpleStation]>(value: [])
  
  init(coreDataStack: CoreDataStorage) {
    self.coreDataStack = coreDataStack
    self.store = PersistenceStore(self.coreDataStack.mainContext)
    self.store.configureResultsController(sortDescriptors: Station.defaultSortDescriptors)
    
    self.store.delegate = self
  }
  
  // MARK: - TODO, Change Over time too?
  
  func isFavorite(station: SimpleStation) -> Observable<Bool> {
    if store.find(with: station) != nil {
      return Observable.just(true)
    } else {
      return Observable.just(false)
    }
  }
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool> {
    if let persistentStation = store.find(with: station) {
      store.delete(with: persistentStation)
      return Observable.just(false)
    } else {
      store.saveFavorite(station)
      return Observable.just(true)
    }
  }
  
  // MARK: - Change over time
  
  func favoritesList() -> Observable<[SimpleStation]> {
    favoriteListSubject.onNext( favoriteEntitiesList() )
    return favoriteListSubject.asObservable()
  }
  
  fileprivate func favoriteEntitiesList() -> [SimpleStation] {
    return store.findAll().map( SimpleStation.init )
  }
}

// MARK: - PersistenceStoreDelegate

extension DefaultFavoritesLocalStorage: PersistenceStoreDelegate {
  
  func persistenceStore(didUpdateEntity update: Bool) {
    favoriteListSubject.onNext( favoriteEntitiesList() )
  }
}
