//
//  AppDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public final class AppDIContainer {
  
  lazy var dataTransferService: DataTransferService = {
    return ApiClient()
  }()
  
  lazy var backendClient: LocalClient = {
    return LocalClient(pathLocalFile: "stations", extensionLocalFile: "json")
  }()

  lazy var analyticsClient: LocalClient = {
    return backendClient
  }()

  lazy var localStorage = CoreDataStorage(maxStorageLimit: 10)
  
  lazy var stationsLocalStorage: StationsLocalStorage = DefaultStationsLocalStorage(coreDataStack: localStorage)
  
  lazy var favoritesLocalStorage: FavoritesLocalStorage = DefaultFavoritesLocalStorage(coreDataStack: localStorage)
}

extension AppDIContainer {
  
  // MARK: - DIContainers Initial
  
  func makeInitialSceneDIContainer() -> InitialSceneDIContainer {
    let dependencies =  InitialSceneDIContainer.Dependencies(
      dataTransferService: backendClient,
      stationsLocalStorage: stationsLocalStorage)
    return InitialSceneDIContainer(dependencies: dependencies)
  }
  
  // MARK: - DIContainers Main
  
  func makeMainSceneDIContainer() -> MainSceneDIContainer {
    let dependencies =  MainSceneDIContainer.Dependencies(
      dataTransferService: dataTransferService,
      stationsLocalStorage: stationsLocalStorage,
      favoritesLocalStorage: favoritesLocalStorage,
      backendTransferService: backendClient,
      analyticsService: analyticsClient)
    
    return MainSceneDIContainer(dependencies: dependencies)
  }
}