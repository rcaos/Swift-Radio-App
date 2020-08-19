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
  
  private var radioPlayer: RadioPlayer!
  
  // MARK: - Initializers
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    self.radioPlayer = makeRadioPlayer()
  }
  
  public func makeMainViewController(coordinator: MainCoordinatorProtocol? = nil) -> MainViewControler {
    return MainViewControler.create(with: makeMainViewModel(coordinator: coordinator),
                                    controllersFactory: self)
  }
  
  public func makePopularViewController(delegate: PopularViewModelDelegate) -> UIViewController {
    let popularDependencies = PopularSceneDIContainer.Dependencies(
      stationsLocalStorage: dependencies.stationsLocalStorage)
    
    return PopularSceneDIContainer(dependencies: popularDependencies).makePopularViewController(delegate: delegate)
  }
  
  public func makeFavoritesViewController(delegate: FavoritesViewModelDelegate) -> UIViewController {
    let favoriteDependencies = FavoriteSceneDIContainer.Dependencies(
      stationsLocalStorage: dependencies.stationsLocalStorage,
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      analyticsService: dependencies.analyticsService)
    
    return FavoriteSceneDIContainer(dependencies: favoriteDependencies).makeFavoriteViewController(delegate: delegate)
  }
  
  public func makeMiniPlayerViewController(with viewModel: MiniPlayerViewModel, delegate: MiniPlayerViewModelDelegate) -> MiniPlayerViewController {
    let miniPlayerDependencies = MiniPlayerSceneDIContainer.Dependencies(
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      radioPlayer: self.radioPlayer,
      analyticsService: dependencies.analyticsService)
    
    return MiniPlayerSceneDIContainer(dependencies: miniPlayerDependencies).makeMiniPlayerViewController(with: viewModel, delegate: delegate)
  }
  
  public func makePlayerViewController(with station: StationRemote) -> PlayerViewController {
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
  
  private func makeMainViewModel(coordinator: MainCoordinatorProtocol?) -> MainViewModel {
    let miniPlayerDependencies = MiniPlayerSceneDIContainer.Dependencies(
      favoritesLocalStorage: dependencies.favoritesLocalStorage,
      radioPlayer: self.radioPlayer,
      analyticsService: dependencies.analyticsService)
    
    let miniPlayerViewModel = MiniPlayerSceneDIContainer(dependencies: miniPlayerDependencies) .makeMiniPlayerViewModel()
    
    let mainViewModel = MainViewModel(miniPlayerViewModel: miniPlayerViewModel)
    mainViewModel.coordinator = coordinator
    return mainViewModel
  }
  
  private func makeRadioPlayer() -> RadioPlayer {
    return RadioPlayer(showDetailsUseCase: makeShowDetailsUseCase(),
                       saveStreamErrorUseCase: makeSaveStationErrorsUseCase(),
                       savePlayingEventUseCase: makePlayingEventUseCase())
  }
  
  private func makeShowDetailsUseCase() -> FetchShowOnlineInfoUseCase {
    return DefaultFetchShowOnlineInfoUseCase(showDetailRepository: makeShowDetailsRepository())
  }
  
  private func makeShowDetailsRepository() -> ShowDetailsRepository {
    return DefaultShowDetailsRepository(dataTransferService: dependencies.dataTransferService)
  }
  
  private func makeSaveStationErrorsUseCase() -> SaveStationStreamError {
    return DefaultSaveStationError(eventsRepository:
      makeEventsRepository( with: dependencies.backendTransferService ))
  }
  
  private func makeEventsRepository(with repository: TransferServiceProtocol) -> EventsRepository {
    return DefaultEventsRepository(dataTransferService: repository)
  }
  
  private func makePlayingEventUseCase() -> SavePlayingEventUseCase {
    return DefaultSavePlayingEventUseCase(analyticsRepository:
      DefaultAnalyticsRepository(analyticsService: dependencies.analyticsService))
  }
}

// Delete this
extension MainSceneDIContainer: MainViewControllersFactory {
  
}

extension MainSceneDIContainer: MainCoordinatorDependencies { }
