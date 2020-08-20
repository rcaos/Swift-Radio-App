//
//  MainSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class MainSceneDIContainer {
  
  struct Dependencies {
    let dataTransferService: DataTransferService
    let stationsLocalStorage: StationsLocalStorage
    let favoritesLocalStorage: FavoritesLocalStorage
    let backendTransferService: TransferServiceProtocol
    let analyticsService: AnalyticsServiceProtocol
  }
  
  private let dependencies: Dependencies
  
  // Long-lived dependencies
  private let radioPlayer: RadioPlayerProtocol
  private let mainViewModel: MainViewModelProtocol
  
  // MARK: - Initializer
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    
    // This init methods are Okey, because RadioPlayer is a Long-Lived Dependency
    
    func makeShowDetailsUseCase() -> FetchShowOnlineInfoUseCase {
      let repository: ShowDetailsRepository = DefaultShowDetailsRepository(dataTransferService: dependencies.dataTransferService)
      return DefaultFetchShowOnlineInfoUseCase(showDetailRepository: repository)
    }
    
    func makeSaveStationErrorsUseCase() -> SaveStationStreamError {
      let repository: EventsRepository = DefaultEventsRepository(dataTransferService: dependencies.backendTransferService)
      return DefaultSaveStationError(eventsRepository: repository)
    }
    
    func makePlayingEventUseCase() -> SavePlayingEventUseCase {
      return DefaultSavePlayingEventUseCase(analyticsRepository:
        DefaultAnalyticsRepository(analyticsService: dependencies.analyticsService))
    }
    
    self.radioPlayer = RadioPlayer(showDetailsUseCase: makeShowDetailsUseCase(),
                                   saveStreamErrorUseCase: makeSaveStationErrorsUseCase(),
                                   savePlayingEventUseCase: makePlayingEventUseCase())
    
    self.mainViewModel = MainViewModel()
  }
  
  // MARK: - Public Api
  
  public func makeMainViewController(coordinator: MainCoordinatorProtocol? = nil) -> MainViewControler {
    return MainViewControler.create(with: makeMainViewModel(coordinator: coordinator),
                                    controllersFactory: self)
  }
  
  public func makePopularViewController() -> UIViewController {
    let popularDependencies = PopularSceneDIContainer.Dependencies(
      stationsLocalStorage: dependencies.stationsLocalStorage)
    
    return PopularSceneDIContainer(dependencies: popularDependencies).makePopularViewController(delegate: mainViewModel)
  }
  
  public func makeFavoritesViewController() -> UIViewController {
    let favoriteDependencies = FavoriteSceneDIContainer.Dependencies(
      stationsLocalStorage: dependencies.stationsLocalStorage,
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      analyticsService: dependencies.analyticsService)
    
    return FavoriteSceneDIContainer(dependencies: favoriteDependencies).makeFavoriteViewController(delegate: mainViewModel)
  }
  
  public func makeMiniPlayerViewController() -> UIViewController {
    guard let miniPlayerViewModel = mainViewModel.miniPlayerViewModel else { fatalError("ViewModel don't create yet.") }
    
    let miniPlayerDependencies = MiniPlayerSceneDIContainer.Dependencies(
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      radioPlayer: self.radioPlayer,
      analyticsService: dependencies.analyticsService)
    
    return MiniPlayerSceneDIContainer(dependencies: miniPlayerDependencies)
      .makeMiniPlayerViewController(with: miniPlayerViewModel, delegate: mainViewModel)
  }
  
  public func makePlayerViewController(with station: StationProp) -> PlayerViewController {
    let playerDependencies = PlayerSceneDIContainer.Dependencies(
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      radioPlayer: self.radioPlayer,
      analyticsService: dependencies.analyticsService)
    
    return PlayerSceneDIContainer(dependencies: playerDependencies).makePlayerViewController(with: station)
  }
  
  public func makeSettingsViewController() -> UIViewController {
    let viewModel = SettingsViewModel()
    return SettingsViewController.create(with: viewModel)
  }
}

// MARK: - Private

extension MainSceneDIContainer {
  
  private func makeMainViewModel(coordinator: MainCoordinatorProtocol?) -> MainViewModelProtocol {
    let miniPlayerDependencies = MiniPlayerSceneDIContainer.Dependencies(
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      radioPlayer: self.radioPlayer,
      analyticsService: dependencies.analyticsService)
    
    let miniPlayerViewModel = MiniPlayerSceneDIContainer(dependencies: miniPlayerDependencies) .makeMiniPlayerViewModel()
    
    mainViewModel.miniPlayerViewModel = miniPlayerViewModel
    mainViewModel.coordinator = coordinator
    return mainViewModel
  }
}

extension MainSceneDIContainer: MainViewControllersFactory { }

extension MainSceneDIContainer: MainCoordinatorDependencies { }
