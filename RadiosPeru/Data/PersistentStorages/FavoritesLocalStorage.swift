//
//  FavoritesLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FavoritesLocalStorage {
  
  func isFavorite(station: SimpleStation) -> Observable<Bool>
  
  func toogleFavorite(station: SimpleStation) -> Observable<Bool>
  
  func favoritesList() -> Observable<[SimpleStation]>
}
