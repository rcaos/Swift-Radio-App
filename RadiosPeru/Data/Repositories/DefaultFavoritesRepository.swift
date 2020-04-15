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
  
  init(favoritesPersistentStorage: FavoritesLocalStorage) {
    self.favoritesPersistentStorage = favoritesPersistentStorage
  }
}

extension DefaultFavoritesRepository: FavoritesRepository {
  
  func isFavorite(station: SimpleStation) -> Observable<Bool> {
    favoritesPersistentStorage.isFavorite(station: station)
  }
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool> {
    favoritesPersistentStorage.toogleFavorite(station: station)
  }
  
  func favoritesList() -> Observable<[SimpleStation]> {
    favoritesPersistentStorage.favoritesList()
  }
}
