//
//  PlayerSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class PlayerSceneDIContainer {
  
  struct Dependencies {
    let favoritesLocalStorage: FavoritesLocalStorage
    let radioPlayer: RadioPlayer
    let analyticsService: AnalyticsServiceProtocol
  }
  
  private let dependencies: Dependencies
  
  private var favoritesRepository: FavoritesRepository!
  
  // MARK: - Initializer
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.favoritesRepository = makeFavoritesRepository()
  }
  
  public func makePlayerViewController(with station: StationRemote) -> PlayerViewController {
    return PlayerViewController.create(with: makePlayerViewModel(with: station))
  }
}

// MARK: - Private

extension PlayerSceneDIContainer {
  
  private func makePlayerViewModel(with station: StationRemote) -> PlayerViewModel {
    return PlayerViewModel(
      toggleFavoritesUseCase: makeToggleFavoritesUseCase(),
      askFavoriteUseCase: makeAskFavoritesUseCase(),
      player: dependencies.radioPlayer,
      station: station)
  }
  
  private func makeToggleFavoritesUseCase() -> ToggleFavoritesUseCase {
    return DefaultToggleFavoriteUseCase(favoritesRepository: self.favoritesRepository)
  }
  
  private func makeAskFavoritesUseCase() -> AskFavoriteUseCase {
    return DefaultAskFavoriteUseCase(favoritesRepository: self.favoritesRepository)
  }
  
  private func makeFavoritesRepository() -> FavoritesRepository {
    return DefaultFavoritesRepository(
      favoritesPersistentStorage: dependencies.favoritesLocalStorage,
      analyticsRepository: DefaultAnalyticsRepository(analyticsService: dependencies.analyticsService) )
  }
}
