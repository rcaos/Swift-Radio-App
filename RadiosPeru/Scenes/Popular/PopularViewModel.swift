//
//  PopularViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel {
    
    var stations:[RadioStation] = []
    var models:[PopularCellViewModel] = []
    
    var miniPlayer: MiniPlayerViewModel
    
    init() {
        stations = RadioStation.createStations()
        models = stations.map({ return PopularCellViewModel(station: $0) })
        miniPlayer = MiniPlayerViewModel(radio: nil)
    }
    
    func selectStation(at index: Int) {
        miniPlayer.configStation(radio: stations[index])
    }
    
}
