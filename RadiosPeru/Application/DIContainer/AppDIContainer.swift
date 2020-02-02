//
//  AppDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class AppDIContainer {

    lazy var dataTransferService: DataTransferService = {
        return ApiClient()
    }()
    
    lazy var localStorage = CoreDataStorage(maxStorageLimit: 10)
    
    lazy var stationsLocalStorage: StationsLocalStorage = localStorage
    
    lazy var favoritesLocalStorage: FavoritesLocalStorage = localStorage
}

extension AppDIContainer {
    
    // MARK : - DIContainers Initial
    
    func makeInitialSceneDIContainer() -> InitialSceneDIContainer {
        let dependencies =  InitialSceneDIContainer.Dependencies(
            dataTransferService: dataTransferService,
            stationsLocalStorage: stationsLocalStorage)
        return InitialSceneDIContainer(dependencies: dependencies)
    }
    
    // MARK : - DIContainers Main
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies =  MainSceneDIContainer.Dependencies(
            dataTransferService: dataTransferService,
            stationsLocalStorage: stationsLocalStorage,
            favoritesLocalStorage: favoritesLocalStorage)
        
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
