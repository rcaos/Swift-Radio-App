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
        
        miniPlayer = MiniPlayerViewModel(name: nil, group: nil, service: radioPlayer)
    }
    
    func selectStation(with station: SimpleStation) {
        miniPlayer.configStation(by: station.name, group: station.group)
    }
}

extension MainViewModel: PopularViewModelDelegate {
    
    func stationDidSelect(station: SimpleStation) {
        selectStation(with: station)
    }
}

extension MainViewModel: FavoritesViewModelDelegate {
    
    func stationFavoriteDidSelect(station: SimpleStation) {
        selectStation(with: station)
    }
}
