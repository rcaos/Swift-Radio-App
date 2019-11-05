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
    
    var miniPlayer: MiniPlayerViewModel
    
    var servicePlayer: RadioPlayer
    
    var stationsManager: StationsManager
    
    init(manager: StationsManager = StationsManager.shared ) {
        
        stationsManager = manager
        stations = stationsManager.findFavorites()
        
        models = stations.map({ return PopularCellViewModel(station: $0) })
        
        servicePlayer = RadioPlayer()
        miniPlayer = MiniPlayerViewModel(radio: nil, service: servicePlayer)
    }
    
    func selectStation(at index: Int) {
        miniPlayer.configStation(radio: stations[index])
    }
    
}
