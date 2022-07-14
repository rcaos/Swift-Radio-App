//
//  MiniPlayerSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Domain
import RadioPlayer
import UIKit

final class MiniPlayerSceneDIContainer {
  
  struct Dependencies {
    let favoritesLocalStorage: FavoritesLocalStorage
    let radioPlayer: RadioPlayerProtocol
    let analyticsService: AnalyticsServiceProtocol
  }
  
  private let dependencies: Dependencies
  
  private var favoritesRepository: FavoritesRepository!
  
  // MARK: - Initializer
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.favoritesRepository = makeFavoritesRepository()
  }
  
  // MARK: - Public Api
  
  public func makeMiniPlayerViewController(with viewModel: MiniPlayerViewModelProtocol,
                                           delegate: MiniPlayerViewModelDelegate) -> MiniPlayerViewController {
    var viewModelMiniPlayer = viewModel
    viewModelMiniPlayer.delegate = delegate
    return MiniPlayerViewController.create(with: viewModel)
  }
  
  public func makeMiniPlayerViewModel() -> MiniPlayerViewModel {
    return MiniPlayerViewModel(
      toggleFavoritesUseCase: makeToggleFavoritesUseCase(),
      askFavoriteUseCase: makeAskFavoritesUseCase(),
      favoritesChangedUseCase: makeFavoritesDidChangeUseCase(),
      player: dependencies.radioPlayer,
      delegate: nil)
  }
}

extension MiniPlayerSceneDIContainer {
  
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
  
  private func makeFavoritesDidChangeUseCase() -> FavoritesDidChangedUseCase {
    return DefaultFavoritesDidChangedUseCase(favoritesRepository: self.favoritesRepository)
  }
}
