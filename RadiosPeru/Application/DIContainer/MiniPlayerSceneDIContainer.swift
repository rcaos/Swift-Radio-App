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
        let radioPlayer: RadioPlayer
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeMiniPlayerViewController(with viewModel: MiniPlayerViewModel, delegate: MiniPlayerViewModelDelegate) -> UIViewController {
        viewModel.delegate = delegate
        return MiniPlayerViewController.create(with: viewModel)
    }
    
    public func makeMiniPlayerViewModel() -> MiniPlayerViewModel {
        return MiniPlayerViewModel(
            player: dependencies.radioPlayer, delegate: nil)
    }
}
