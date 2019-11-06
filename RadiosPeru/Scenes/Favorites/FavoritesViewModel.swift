//
//  FavoritesViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class FavoritesViewModel {
    
    var stations:[RadioStation] = []
    var models:[PopularCellViewModel] = []
    
    var stationsManager: StationsManager
    
    //Reactive
    var updateUI: (() -> Void)?
    
    init(manager: StationsManager) {
        stationsManager = manager
        manager.addObserver(self)
        
        getFavorites()
    }
    
    func selectStation(at index: Int) -> RadioStation {
        return stations[index]
    }
    
    func refreshStations() {
        getFavorites()
        updateUI?()
    }
    
    //MARK: - Private
    private func getFavorites() {
        stations = stationsManager.findFavorites()
        models = stations.map({ return PopularCellViewModel(station: $0) })
    }
    
}

extension FavoritesViewModel: StationsManagerObserver {
    
    func stationsManagerDidChangeFavorites(_ manager: StationsManager) {
        refreshStations()
    }
}
