//
//  InitialSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class InitialSceneDIContainer {
  
  struct Dependencies {
    let dataTransferService: DataTransferService
    let stationsLocalStorage: StationsLocalStorage
  }
  
  private let dependencies: Dependencies
  
  // MARK: - Initializers
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  public func buildInitialViewController(coordinator: InitialCoordinatorProtocol? = nil) -> UIViewController {
    return InitialViewController.create(with: makeInitialViewModel(coordinator: coordinator))
  }
}

// MARK: - Private

extension InitialSceneDIContainer {
  
  private func makeInitialViewModel(coordinator: InitialCoordinatorProtocol?) -> InitialViewModel {
    let initialVM = InitialViewModel(fetchStationsUseCase: makeFetchStationsUseCase())
    initialVM.coordinator = coordinator
    return initialVM
  }
  
  // MARK: - Use Cases
  
  private func makeFetchStationsUseCase() -> FetchStationsUseCase {
    return DefaultFetchStationsUseCase(
      stationsRepository: makeStationsRepository(),
      stationsLocalRepository: makeStationsLocalRepository())
  }
  
  // MARK: - Repositories
  
  private func makeStationsRepository() -> StationsRepository {
    return DefaultStationsRepository(dataTransferService: dependencies.dataTransferService)
  }
  
  private func makeStationsLocalRepository() -> StationsLocalRepository {
    return DefaultStationsLocalRepository(stationsPersistentStorage: dependencies.stationsLocalStorage)
  }
}

extension InitialSceneDIContainer: InitialCoordinatorDependencies { }
