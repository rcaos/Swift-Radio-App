//
//  DefaultFavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultFavoritesRepository {
    
    private var favoritesPersistentStorage: FavoritesLocalStorage
    
    init(favoritesPersistentStorage: FavoritesLocalStorage) {
        self.favoritesPersistentStorage = favoritesPersistentStorage
    }
}

extension DefaultFavoritesRepository: FavoritesRepository {
    
    func isFavorite(station: SimpleStation, completion: @escaping (Result<Bool, Error>) -> Void) {
        favoritesPersistentStorage.isFavorite(station: station, completion: completion)
    }
    
    func toogleFavorite(station: SimpleStation, completion: @escaping (Result<Bool, Error>) -> Void) {
        favoritesPersistentStorage.toogleFavorite(station: station, completion: completion)
    }
    
    func favoritesList(completion: @escaping (Result<[SimpleStation], Error>) -> Void) {
        favoritesPersistentStorage.favoritesList(completion: completion)
    }
}
