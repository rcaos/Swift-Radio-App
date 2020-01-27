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
    
    private let toggleFavoritesUseCase: ToggleFavoritesUseCase
    
    private let askFavoriteUseCase: AskFavoriteUseCase
    
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
    
    init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
         askFavoriteUseCase: AskFavoriteUseCase,
         player: RadioPlayer?,
         delegate: MiniPlayerViewModelDelegate? = nil) {
        
        self.toggleFavoritesUseCase = toggleFavoritesUseCase
        self.askFavoriteUseCase = askFavoriteUseCase
        
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
        guard let selected = stationSelected else { return }
        
        let simpleStation = SimpleStation(name: selected.name, group: selected.group)
        
        let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
        
        toggleFavoritesUseCase.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let isFavorite):
                strongSelf.isFavorite.value = isFavorite
            case .failure: break
            }
        }
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
        self.isFavorite.value = false
        
        checkIsFavorite(with: stationSelected)
    }
    
    private func checkIsFavorite(with station: StationRemote?) {
        guard let station = station else { return  }
        
        let simpleStation = SimpleStation(name: station.name, group: station.group)
        let request = AskFavoriteUseCaseRequestValue(station: simpleStation)
        
        askFavoriteUseCase.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let isFavorite):
                strongSelf.isFavorite.value = isFavorite
            case .failure: break
            }
        }
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
