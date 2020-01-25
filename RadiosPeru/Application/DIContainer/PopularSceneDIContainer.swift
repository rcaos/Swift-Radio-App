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
        let dataTransferService: DataTransferService
        let stationsLocalStorage: StationsLocalStorage
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makePopularViewController() -> UIViewController {
        return PopularViewController.create(with: makePopularViewModel())
    }
}

// MARK: - Private

extension PopularSceneDIContainer {
    
    private func makePopularViewModel() -> PopularViewModel {
        return PopularViewModel(fetchStationsUseCase: makeFetchStationsUseCase())
    }
    
    private func makeFetchStationsUseCase() -> FetchStationsLocalUseCase {
        return DefaultFetchStationsLocalUseCase(stationsLocalRepository: makeStationsLocalRepository())
    }
    
    private func makeStationsLocalRepository() -> StationsLocalRepository {
        return DefaultStationsLocalRepository(stationsPersistentStorage: dependencies.stationsLocalStorage)
    }
}
