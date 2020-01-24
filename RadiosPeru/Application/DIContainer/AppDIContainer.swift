//
//  AppDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - TODO, Las URLS son completamente diferentes !!
    // Group RPP: tiene base fixed
    // Group CRP: tiene bases variables
    
    lazy var dataTransferService: DataTransferService = {
        return ApiClient()
    }()
}

extension AppDIContainer {
    
    // MARK : - DIContainers Initial
    
    func makeInitialSceneDIContainer() -> InitialSceneDIContainer {
        let dependencies =  InitialSceneDIContainer.Dependencies(datTransferService: dataTransferService)
        return InitialSceneDIContainer(dependencies: dependencies)
    }
    
    // MARK : - DIContainers Main
    
     func makeMainSceneDIContainer() -> MainSceneDIContainer {
         let dependencies =  MainSceneDIContainer.Dependencies(datTransferService: dataTransferService)
         return MainSceneDIContainer(dependencies: dependencies)
     }
}
