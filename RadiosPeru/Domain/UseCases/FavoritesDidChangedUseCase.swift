//
//  FavoritesDidChangedUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FavoritesDidChangedUseCase {
  
  func execute(requestValue: FavoritesDidChangedUseCaseRequestValue) -> Observable<Void>
}

struct FavoritesDidChangedUseCaseRequestValue {
  
}

final class DefaultFavoritesDidChangedUseCase: FavoritesDidChangedUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  func execute(requestValue: FavoritesDidChangedUseCaseRequestValue) -> Observable<Void> {
    return favoritesRepository.favoritesDidChanged()
  }
  
}
