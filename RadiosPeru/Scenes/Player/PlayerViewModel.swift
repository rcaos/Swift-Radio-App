//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

final class PlayerViewModel {
    
    private var radioStation: RadioStation
    
    var name: String?
    var image: String?
    var description: String?
    
    //Init
    init(station: RadioStation) {
        self.radioStation = station
        setupRadio(for: station)
    }
    
    //MARK: - Private
    func setupRadio(for station: RadioStation) {
        name = radioStation.name
        image = radioStation.image
        description = radioStation.city + " " +
                        radioStation.frecuency
    }
    
}
