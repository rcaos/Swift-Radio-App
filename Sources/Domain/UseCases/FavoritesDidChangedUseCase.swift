//
//  FavoritesDidChangedUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FavoritesDidChangedUseCase {
  func execute(requestValue: FavoritesDidChangedUseCaseRequestValue) -> Observable<Void>
}

public struct FavoritesDidChangedUseCaseRequestValue {
  public init() { }
}

public final class DefaultFavoritesDidChangedUseCase: FavoritesDidChangedUseCase {
  
  private let favoritesRepository: FavoritesRepository
  
  public init(favoritesRepository: FavoritesRepository) {
    self.favoritesRepository = favoritesRepository
  }
  
  public func execute(requestValue: FavoritesDidChangedUseCaseRequestValue) -> Observable<Void> {
    return favoritesRepository.favoritesDidChanged()
  }
  
}
