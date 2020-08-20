//
//  FavoriteSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class FavoriteSceneDIContainer {
  
  struct Dependencies {
    let stationsLocalStorage: StationsLocalStorage
    let favoritesLocalStorage: FavoritesLocalStorage
    let analyticsService: AnalyticsServiceProtocol
  }
  
  private let dependencies: Dependencies
  
  private var defaultRepository: FavoritesRepository!
  
  // MARK: - Initializer
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    defaultRepository = makeFavoritesRepository()
  }
  
  // MARK: - Public Api
  
  public func makeFavoriteViewController(delegate: FavoritesViewModelDelegate) -> UIViewController {
    return FavoritesViewController.create(with:
      makeFavoriteViewModel(delegate: delegate))
  }
}

// MARK: - Private

extension FavoriteSceneDIContainer {
  
  private func makeFavoriteViewModel(delegate: FavoritesViewModelDelegate) -> FavoritesViewModel {
    return FavoritesViewModel(fetchFavoritesUseCase: makeFetchFavoriteStationsUseCase(),
                              toggleFavoritesUseCase: makeToggleFavoriteUseCase(),
                              delegate: delegate)
  }
  
  private func makeFetchFavoriteStationsUseCase() -> FetchFavoritesStationsUseCase {
    return DefaultFetchFavoritesStationsUseCase(
      favoritesRepository: self.defaultRepository ,
      localsRepository: makeStationsLocalRepository())
  }
  
  private func makeFavoritesRepository() -> FavoritesRepository {
    return DefaultFavoritesRepository(
      favoritesPersistentStorage: dependencies.favoritesLocalStorage,
      analyticsRepository: DefaultAnalyticsRepository(analyticsService: dependencies.analyticsService) )
  }
  
  private func makeStationsLocalRepository() -> StationsLocalRepository {
    return DefaultStationsLocalRepository(stationsPersistentStorage: dependencies.stationsLocalStorage)
  }
  
  private func makeToggleFavoriteUseCase() -> ToggleFavoritesUseCase {
    return DefaultToggleFavoriteUseCase(favoritesRepository: self.defaultRepository)
  }
  
}
