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
    
    init() {
        stations = RadioStation.createStations()
        models = stations.map({ return PopularCellViewModel(station: $0) })
    }
    
    //MARK: - Build Models
    func buildModel(for player: Int) -> PlayerViewModel {
        return PlayerViewModel(station: stations[player] )
    }
}
