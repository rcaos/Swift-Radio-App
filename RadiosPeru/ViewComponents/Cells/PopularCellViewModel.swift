//
//  PopularViewCellViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PopularCellViewModel {
    
    var radioStation: StationRemote
    
    lazy var image: String = {
        return radioStation.image
    }()
    
    init(station: StationRemote) {
        self.radioStation = station
    }
    
}
