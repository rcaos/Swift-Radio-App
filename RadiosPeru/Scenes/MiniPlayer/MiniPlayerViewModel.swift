//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol MiniPlayerViewModelDelegate: class {
    
    func stationPLayerDidSelect(station: StationRemote)
}

final class MiniPlayerViewModel {
        
    private var radioPlayer: RadioPlayer?
    
    private var stationSelected: StationRemote?
    
    var name: String = "Pick a Radio Station"
    
    weak var delegate: MiniPlayerViewModelDelegate?
    
    var isSelected: Bool {
        stationSelected != nil
    }
    
    var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
    
    var updateUI:(()-> Void)?
    
    var isFavorite: Bindable<Bool> = Bindable(false)
    
    //MARK: - Initializers
    
    init(player: RadioPlayer?, delegate: MiniPlayerViewModelDelegate? = nil) {
        radioPlayer = player
        radioPlayer?.addObserver(self)
        self.delegate = delegate
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
        
    //MARK: - Public
    
    func showPlayer() {
        guard let selected = stationSelected else { return }
        delegate?.stationPLayerDidSelect(station: selected)
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
