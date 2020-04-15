//
//  FavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FavoritesRepositoryDelegate: class {
  
  func stationsLocalRepository(didUpdateEntity update: Bool)
}

protocol FavoritesRepository {
  
  func isFavorite(station: SimpleStation) -> Observable<Bool>
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool>
  
  func favoritesList() -> Observable<[SimpleStation]>
  
  func configStore()
  
  var delegate: FavoritesRepositoryDelegate? { get set }
}
