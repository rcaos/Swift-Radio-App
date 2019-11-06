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
    
    init(manager: StationsManager) {
        
        stationsManager = manager
        stations = stationsManager.findFavorites()
        
        models = stations.map({ return PopularCellViewModel(station: $0) })
    }
    
    func selectStation(at index: Int) -> RadioStation {
        return stations[index]
    }
    
}
