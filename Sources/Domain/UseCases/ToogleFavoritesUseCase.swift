//
//  ToggleFavoritesUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol ToggleFavoritesUseCase {
  
  func execute(requestValue: ToggleFavoriteUseCaseRequestValue) -> Observable<Bool>
}

public struct ToggleFavoriteUseCaseRequestValue {
  let station: SimpleStation

  public init(station: SimpleStation) {
    self.station = station
  }
}

public final class DefaultToggleFavoriteUseCase: ToggleFavoritesUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  public init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  public func execute(requestValue: ToggleFavoriteUseCaseRequestValue) -> Observable<Bool> {
    
    return favoritesRepository.toogleFavorite(station: requestValue.station)
  }
}
