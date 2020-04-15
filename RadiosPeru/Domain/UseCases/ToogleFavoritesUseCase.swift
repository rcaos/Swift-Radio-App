//
//  ToggleFavoritesUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol ToggleFavoritesUseCase {
  
  func execute(requestValue: ToggleFavoriteUseCaseRequestValue) -> Observable<Bool>
}

struct ToggleFavoriteUseCaseRequestValue {
  let station: SimpleStation
}

final class DefaultToggleFavoriteUseCase: ToggleFavoritesUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  func execute(requestValue: ToggleFavoriteUseCaseRequestValue) -> Observable<Bool> {
    
    return favoritesRepository.toogleFavorite(station: requestValue.station)
  }
}
