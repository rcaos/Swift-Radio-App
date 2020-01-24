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
        let datTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - TODO Persistence
    //lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataStorage(maxStorageLimit: 10)
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - TODO
    
    public func makeInitialViewController() -> UIViewController {
        return InitialViewController.create(with: makeInitialViewModel())
    }
}

// MARK: - Private

extension InitialSceneDIContainer {
    
    private func makeInitialViewModel() -> InitialViewModel {
        return InitialViewModel(fetchStationsUseCase: makeFetchStationsUseCase())
    }
    
    // MARK: - Use Cases
    
    private func makeFetchStationsUseCase() -> FetchStationsUseCase {
        return DefaultFetchStationsUseCase(
            stationsRepository: makeStationsRepository(),
            stationsLocalRepository: nil)
    }
    
    // MARK: - Repositories
    
    private func makeStationsRepository() -> StationsRepository {
        return DefaultStationsRepository(dataTransferService: dependencies.datTransferService)
    }
}
