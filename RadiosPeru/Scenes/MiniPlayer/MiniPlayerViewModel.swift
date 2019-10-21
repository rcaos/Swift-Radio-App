//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MiniPlayerViewModel {
    
    private var radioStation: RadioStation!
    
    var fullName: String = "Pick a Radio Station"
    
    var isSelected: Bool {
        return (radioStation != nil)
    }
    
    //Reactive
    var updateRadioDetail: (() -> Void)?
    
    //MARK: - Initializers
    
    init(radio: RadioStation?) {
        if let station = radio {
            setupRadio(station)
        }
    }
    
    func configStation(radio: RadioStation) {
        setupRadio(radio)
        updateRadioDetail?()
    }
    
    //MARK: - Private
    
    private func setupRadio(_ station: RadioStation) {
        radioStation = station
        fullName = station.name + station.description
    }
 
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel {
        return PlayerViewModel(station: radioStation)
    }
}
