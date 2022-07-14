//
//  DefaultFavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultFavoritesRepository {
  
  private var favoritesPersistentStorage: FavoritesLocalStorage
  private let analyticsRepository: AnalyticsRepository
  
  init(favoritesPersistentStorage: FavoritesLocalStorage, analyticsRepository: AnalyticsRepository) {
    self.favoritesPersistentStorage = favoritesPersistentStorage
    self.analyticsRepository = analyticsRepository
  }
}

extension DefaultFavoritesRepository: FavoritesRepository {
  
  func isFavorite(station: SimpleStation) -> Observable<Bool> {
    favoritesPersistentStorage.isFavorite(station: station)
  }
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool> {
    return
      favoritesPersistentStorage.toogleFavorite(station: station)
        .do(onNext: { [weak self] result in
          guard let strongSelf = self else { return }
          let event = EventFavorite(statioName: station.name)
          
          if result {
            _ = strongSelf.analyticsRepository.addFavorite(event: event)
          } else {
            _ = strongSelf.analyticsRepository.removeFavorite(event: event)
          }
        })
  }
  
  func favoritesList() -> Observable<[SimpleStation]> {
    favoritesPersistentStorage.favoritesList()
  }
  
  func favoritesDidChanged() -> Observable<Void> {
    favoritesPersistentStorage.favoritesDidChanged()
  }
}
