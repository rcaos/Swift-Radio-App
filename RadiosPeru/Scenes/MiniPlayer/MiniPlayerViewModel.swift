//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class MiniPlayerViewModel {
        
    private var radioPlayer: RadioPlayer?
    
    private var stationSelected: StationRemote?
    
    var name: String = "Pick a Radio Station"
    
    // MARK: - TODO
    var isSelected: Bool {
        stationSelected != nil
    }
    
    //Reactive
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(()-> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(service: RadioPlayer?) {
        radioPlayer = service
        radioPlayer?.addObserver(self)
    }
    
    deinit {
        radioPlayer?.removeObserver(self)
    }
    
    //MARK: - Public
    
    func configStation(with station: StationRemote, playAutomatically: Bool = true) {
        stationSelected = station
        
        setupRadio(station)
        
        viewState.value = .stopped
        radioPlayer?.setupRadio(with: station, playWhenReady: playAutomatically)
    }
    
    func togglePlayPause() {
        guard let player = radioPlayer else { return }
        player.togglePlayPause()
    }
    
    func markAsFavorite() {
        //guard let selected = getSelectedStation() else { return }
//        isFavorite.value = favoritesStore.toggleFavorite(with: selected.name, group: selected.group)
    }
    
    func refreshStatus() {
        guard let player = radioPlayer else { return }
        viewState.value = player.state
        
        //guard let selected = getSelectedStation() else { return }
        //setupRadio( selected )
    }
    
    func getDescription() -> String {
        guard let radioPlayer = radioPlayer else { return "" }
        
        return radioPlayer.getRadioDescription()
    }
    
    //MARK: - Private
    
    private func setupRadio(_ radio: StationRemote) {
        self.name = radio.name
        
//        isFavorite.value = favoritesStore.isFavorite(with: radio.name, group: radio.group)
    }
        
    //MARK: - View Models Building
    
    func buildPlayerViewModel() -> PlayerViewModel? {
//        guard let name = self.nameSelected, let group = self.groupSelected else { return nil }
//
//        return PlayerViewModel(name: name, group: group, player: radioPlayer)
        return nil
    }
}


//MARK: - RadioPlayerObserver

extension MiniPlayerViewModel: RadioPlayerObserver {
    
    func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
        viewState.value = state
    }
    
    func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
        updateUI?()
    }
    
}
