//
//  FavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FavoritesRepositoryDelegate: class {
  
  func stationsLocalRepository(didUpdateEntity update: Bool)
}

protocol FavoritesRepository {
  
  func isFavorite(station: SimpleStation,
                  completion: @escaping (Result<Bool, Error>) -> Void)
  
  func toogleFavorite(station: SimpleStation,
                      completion: @escaping (Result<Bool, Error>) -> Void)
  
  func favoritesList(completion: @escaping (Result<[SimpleStation], Error>) -> Void)
  
  func configStore()
  
  var delegate: FavoritesRepositoryDelegate? { get set }
}
