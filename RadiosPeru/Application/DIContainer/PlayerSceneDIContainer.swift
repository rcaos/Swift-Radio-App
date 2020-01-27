//
//  PlayerSceneDIContainer.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class PlayerSceneDIContainer {
    
    struct Dependencies {
        let radioPlayer: RadioPlayer
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeMiniPlayerViewController(with station: StationRemote) -> UIViewController {
        return PlayerViewController.create(with:
            makePlayerViewModel(with: station))
    }
}

// MARK: - Private

extension PlayerSceneDIContainer {
    
    private func makePlayerViewModel(with station: StationRemote) -> PlayerViewModel {
        return PlayerViewModel(
            player: dependencies.radioPlayer, station: station)
    }
}
