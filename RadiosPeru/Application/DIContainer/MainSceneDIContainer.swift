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
        let datTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeMainViewController() -> UIViewController {
        return MainViewControler.create(with: makeMainViewModel())
    }
}

// MARK: - Private

extension MainSceneDIContainer {
    
    private func makeMainViewModel() -> MainViewModel {
        return MainViewModel(radioPlayer: makeRadioPlayer())
    }
    
    private func makeRadioPlayer() -> RadioPlayer {
        return RadioPlayer(showDetailsUseCase: makeShowDetailsUseCase())
    }
    
    private func makeShowDetailsUseCase() -> FetchShowOnlineInfoUseCase {
        return DefaultFetchShowOnlineInfoUseCase(showDetailRepository: makeShowDetailsRepository())
    }
    
    private func makeShowDetailsRepository() -> ShowDetailsRepository {
        return DefaultShowDetailsRepository(dataTransferService: dependencies.datTransferService)
    }
}
