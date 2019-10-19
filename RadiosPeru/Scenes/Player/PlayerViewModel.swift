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
    
    var radioStation: RadioStation
    
    lazy var name: String = {
        return self.radioStation.name
    }()
    
    lazy var image: String = {
        return self.radioStation.image
    }()
    
    lazy var description: String = {
        return self.radioStation.description
    }()
    
    //Init
    init(station: RadioStation) {
        self.radioStation = station
    }
    
}
