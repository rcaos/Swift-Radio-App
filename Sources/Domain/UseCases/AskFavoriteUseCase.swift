//
//  AskFavoriteUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol AskFavoriteUseCase {
  func execute(requestValue: AskFavoriteUseCaseRequestValue) -> Observable<Bool>
}

public struct AskFavoriteUseCaseRequestValue {
  let station: SimpleStation

  public init(station: SimpleStation) {
    self.station = station
  }
}

public final class DefaultAskFavoriteUseCase: AskFavoriteUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  public init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  public func execute(requestValue: AskFavoriteUseCaseRequestValue) -> Observable<Bool> {
    return favoritesRepository.isFavorite(station: requestValue.station)
  }
  
}
