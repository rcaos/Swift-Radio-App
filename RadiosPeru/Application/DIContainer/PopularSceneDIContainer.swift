//
//  PopularSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class PopularSceneDIContainer {
  
  struct Dependencies {
    let stationsLocalStorage: StationsLocalStorage
  }
  
  private let dependencies: Dependencies
  
  // MARK: - Initializer
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Public Api
  
  public func makePopularViewController(delegate: PopularViewModelDelegate) -> UIViewController {
    return PopularViewController.create(with:
      makePopularViewModel(delegate: delegate))
  }
}

// MARK: - Private

extension PopularSceneDIContainer {
  
  private func makePopularViewModel(delegate: PopularViewModelDelegate) -> PopularViewModel {
    return PopularViewModel(fetchStationsUseCase: makeFetchStationsUseCase(), delegate: delegate)
  }
  
  private func makeFetchStationsUseCase() -> FetchStationsLocalUseCase {
    return DefaultFetchStationsLocalUseCase(stationsLocalRepository: makeStationsLocalRepository())
  }
  
  private func makeStationsLocalRepository() -> StationsLocalRepository {
    return DefaultStationsLocalRepository(stationsPersistentStorage: dependencies.stationsLocalStorage)
  }
}
