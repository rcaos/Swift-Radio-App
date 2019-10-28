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
    
    private var servicePlayer: RadioPlayer?
    
    private var radioStation: RadioStation
    
    var image: String?
    
    var name: String?
    
    var defaultDescription: String?
    
    var onlineDescription: String?
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    //MARK: - Initializers
    
    init(station: RadioStation, service: RadioPlayer?) {
        self.radioStation = station
        self.servicePlayer = service
        servicePlayer?.delegate = self
        setupRadio(for: station)
        refreshStatus()
    }
    
    //MARK: - Private
    
    private func setupRadio(for station: RadioStation) {
        name = radioStation.name
        image = radioStation.image
        defaultDescription = radioStation.city + " " +
                        radioStation.frecuency + " " +
                        radioStation.slogan
        onlineDescription = "Currently Program..."
    }
    
    //MARK: - Public
    func togglePlayPause() {
        guard let service = servicePlayer else { return }
        service.togglePlayPause()
    }
    
    func markAsFavorite() {
        print("Mark as Favorite..")
    }
    
    func refreshStatus() {
        guard let service = servicePlayer else { return }
        viewState.value = service.state
    }
}

extension PlayerViewModel : RadioPlayerDelegate {
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        print("Soy Delegate PlayerViewModel, recibo state: \(state)")
        viewState.value = state
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeTrack track: String) {
        
    }
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeImage image: String) {
        
    }
}
