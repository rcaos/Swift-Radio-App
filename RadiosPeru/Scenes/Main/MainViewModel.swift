//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import CoreData

final class MainViewModel {
    
    var miniPlayer: MiniPlayerViewModel
    
    var radioPlayer: RadioPlayer
    
    init(radioPlayer: RadioPlayer) {
        self.radioPlayer = radioPlayer
        
        miniPlayer = MiniPlayerViewModel(service: radioPlayer)
    }
    
    func selectStation(with station: StationRemote) {
        miniPlayer.configStation(with: station)
    }
}

extension MainViewModel: PopularViewModelDelegate {
    
    func stationDidSelect(station: StationRemote) {
        selectStation(with: station)
    }
}

extension MainViewModel: FavoritesViewModelDelegate {
    
    func stationFavoriteDidSelect(station: StationRemote) {
        selectStation(with: station)
    }
}
