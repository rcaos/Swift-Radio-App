//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PlayerViewModel {
    
    private var radioPlayer: RadioPlayer?
    
    private var stationSelected: StationRemote
    
    var image: String?
    
    var name: String?
    
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(() -> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(player: RadioPlayer?, station: StationRemote) {
        self.stationSelected = station
        self.radioPlayer = player
        radioPlayer?.addObserver(self)
        
        setupRadio(with: stationSelected)
    }
    
    deinit {
        radioPlayer?.removeObserver(self)
    }
    
    //MARK: - Private
    
    private func setupRadio(with station: StationRemote) {
        name = station.name
        image = station.image
        
//        isFavorite.value = favoritesStore.isFavorite(with: radioStation.name, group: radioStation.group)
    }
    
    //MARK: - Public
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
//        isFavorite.value = favoritesStore.toggleFavorite(with: nameSelected, group: groupSelected)
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        viewState.value = player.state
        
        if case .playing = viewState.value {
            player.refreshOnlineInfo()
        }
    }
    
    func getDescription() -> String {
        guard let radioPlayer = radioPlayer else { return "" }
        
        return radioPlayer.getRadioDescription()
    }
}

//MARK: - RadioPlayerObserver

extension PlayerViewModel : RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        viewState.value = state
    }
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
        updateUI?()
    }
    
}
