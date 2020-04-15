//
//  AskFavoriteUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol AskFavoriteUseCase {
  
  func execute(requestValue: AskFavoriteUseCaseRequestValue) -> Observable<Bool>
}

struct AskFavoriteUseCaseRequestValue {
  let station: SimpleStation
}

final class DefaultAskFavoriteUseCase: AskFavoriteUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  func execute(requestValue: AskFavoriteUseCaseRequestValue) -> Observable<Bool> {
    return favoritesRepository.isFavorite(station: requestValue.station)
  }
  
}
