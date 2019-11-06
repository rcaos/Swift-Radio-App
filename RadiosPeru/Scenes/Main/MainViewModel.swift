//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MainViewModel {
    
    var miniPlayer: MiniPlayerViewModel
    
    var stationsManager: StationsManager
    
    var servicePlayer: RadioPlayer
    
    init(manager: StationsManager = StationsManager.shared) {
        
        stationsManager = manager
        
        servicePlayer = RadioPlayer()
        
        miniPlayer = MiniPlayerViewModel(radio: nil, service: servicePlayer)
    }
    
    func selectStation(at station: RadioStation) {
        miniPlayer.configStation(radio: station)
    }
    
    //MARK: - Builds Model
    
    func buildPopularViewModel() -> PopularViewModel {
        return PopularViewModel(manager: stationsManager)
    }
    
    func buildFavoriteViewModel() -> FavoritesViewModel {
        return FavoritesViewModel(manager: stationsManager)
    }
}
