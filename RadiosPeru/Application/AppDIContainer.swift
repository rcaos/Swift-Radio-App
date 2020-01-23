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
        return ApiClientNew<StationProvider>()
    }()
}

extension AppDIContainer {
    
    // MARK : - DIContainers Airing Today
    
    func makeInitialSceneDIContainer() -> InitialSceneDIContainer {
        let dependencies =  InitialSceneDIContainer.Dependencies(datTransferService: dataTransferService)
        return InitialSceneDIContainer(dependencies: dependencies)
    }
    
    // MARK : - DIContainers Popular
    
     
    
    
    // MARK : - DIContainers Search
    
     
}
