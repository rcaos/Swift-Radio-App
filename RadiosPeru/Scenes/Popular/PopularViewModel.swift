//
//  PopularViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularViewModel {
    
    var popularCells: [PopularCellViewModel] {
        let popularStations = PersistenceManager.shared.stations
        return popularStations.map{ PopularCellViewModel(station: $0) }
    }
    
    var selectedRadioStation: ((String, String) -> Void)?
    
    init() {
        
    }
    
    func getStationSelection(by index: Int) {
        let stations = PersistenceManager.shared.stations
        let selectedStation = stations[index]
        selectedRadioStation?( selectedStation.name, selectedStation.group )
    }
    
}
