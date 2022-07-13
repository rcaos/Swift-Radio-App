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
  
  private let favoritesDidChangedSubject = BehaviorSubject<Void>(value: ())
  
  init(coreDataStack: CoreDataStorage) {
    self.coreDataStack = coreDataStack
    self.store = PersistenceStore(self.coreDataStack.mainContext)
    self.store.configureResultsController(sortDescriptors: Station.defaultSortDescriptors)
    
    self.store.delegate = self
  }
  
  func isFavorite(station: SimpleStation) -> Observable<Bool> {
    if store.find(with: station) != nil {
      return Observable.just(true)
    } else {
      return Observable.just(false)
    }
  }
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool> {
    return Observable<Bool>.create { [unowned self] (event) -> Disposable in
      let disposable = Disposables.create()
      
      if let persistentStation = self.store.find(with: station) {
        
        self.store.delete(with: persistentStation) {
          event.onNext(false)
          event.onCompleted()
        }
      } else {
        
        self.store.saveFavorite(station) {
          event.onNext(true)
          event.onCompleted()
        }
      }
      return disposable
    }
  }
  
  // MARK: - Change over time
  
  func favoritesDidChanged() -> Observable<Void> {
    return favoritesDidChangedSubject.asObservable()
  }
  
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
    favoritesDidChangedSubject.onNext( () )
  }
}
