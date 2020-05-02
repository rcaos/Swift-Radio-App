//
//  AppDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Firebase

final class AppDIContainer {
  
  lazy var dataTransferService: DataTransferService = {
    return ApiClient()
  }()
  
  lazy var localClient: DataTransferService = {
    return LocalClient(pathLocalFile: "stations", extensionLocalFile: "json")
  }()
  
  // Require a valid 'GoogleService-Info.plist'
  // Please visit https://firebase.google.com/docs/ios/setup?authuser=0
  lazy var fireStoreClient: FireStoreClient? = {
    return nil
  }()
//  lazy var fireStoreClient: FireStoreClient = {
//    FirebaseApp.configure()
//    return FireStoreClient(stationsCollection: "stations")
//  }()
  
  lazy var analyticsClient: AnalyticsClient = {
    FirebaseApp.configure()
    return AnalyticsClient()
  }()
  
  lazy var localStorage = CoreDataStorage(maxStorageLimit: 10)
  
  lazy var stationsLocalStorage: StationsLocalStorage = DefaultStationsLocalStorage(coreDataStack: localStorage)
  
  lazy var favoritesLocalStorage: FavoritesLocalStorage = DefaultFavoritesLocalStorage(coreDataStack: localStorage)
}

extension AppDIContainer {
  
  // MARK: - DIContainers Initial
  
  func makeInitialSceneDIContainer() -> InitialSceneDIContainer {
    let dependencies =  InitialSceneDIContainer.Dependencies(
      dataTransferService: localClient,
      stationsLocalStorage: stationsLocalStorage)
    return InitialSceneDIContainer(dependencies: dependencies)
  }
  
  // MARK: - DIContainers Main
  
  func makeMainSceneDIContainer() -> MainSceneDIContainer {
    let dependencies =  MainSceneDIContainer.Dependencies(
      dataTransferService: dataTransferService,
      stationsLocalStorage: stationsLocalStorage,
      favoritesLocalStorage: favoritesLocalStorage,
      backendTransferService: fireStoreClient,
      analyticsService: analyticsClient)
    
    return MainSceneDIContainer(dependencies: dependencies)
  }
}
