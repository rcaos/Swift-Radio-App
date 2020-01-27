//
//  MiniPlayerSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class MiniPlayerSceneDIContainer {
    
    struct Dependencies {
        let favoritesLocalStorage: FavoritesLocalStorage
        let radioPlayer: RadioPlayer
    }
    
    private let dependencies: Dependencies
    
    private var favoritesRepository: FavoritesRepository!
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.favoritesRepository = makeFavoritesRepository()
    }
    
    public func makeMiniPlayerViewController(with viewModel: MiniPlayerViewModel, delegate: MiniPlayerViewModelDelegate) -> UIViewController {
        viewModel.delegate = delegate
        return MiniPlayerViewController.create(with: viewModel)
    }
    
    public func makeMiniPlayerViewModel() -> MiniPlayerViewModel {
        return MiniPlayerViewModel(
            toggleFavoritesUseCase: makeToggleFavoritesUseCase(),
            askFavoriteUseCase: makeAskFavoritesUseCase(),
            player: dependencies.radioPlayer,
            delegate: nil)
    }
}

extension MiniPlayerSceneDIContainer {
    
    private func makeToggleFavoritesUseCase() -> ToggleFavoritesUseCase {
        return DefaultToggleFavoriteUseCase(favoritesRepository: self.favoritesRepository)
    }
    
    private func makeAskFavoritesUseCase() -> AskFavoriteUseCase {
        return DefaultAskFavoriteUseCase(favoritesRepository: self.favoritesRepository)
    }
    
    private func makeFavoritesRepository() -> FavoritesRepository {
        return DefaultFavoritesRepository(favoritesPersistentStorage: dependencies.favoritesLocalStorage)
    }
}
