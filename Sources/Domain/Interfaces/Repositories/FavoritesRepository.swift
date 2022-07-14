//
//  FavoritesRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FavoritesRepository {
  
  func isFavorite(station: SimpleStation) -> Observable<Bool>
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool>
  
  func favoritesList() -> Observable<[SimpleStation]>
  
  func favoritesDidChanged() -> Observable<Void>
}
