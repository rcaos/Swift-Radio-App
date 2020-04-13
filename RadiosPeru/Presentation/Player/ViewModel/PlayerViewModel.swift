//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class PlayerViewModel {
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private let askFavoriteUseCase: AskFavoriteUseCase
  
  private var radioPlayer: RadioPlayer?
  
  private var stationSelected: StationRemote
  
  var image: URL?
  
  var name: String?
  
  var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
  
  var updateUI:(() -> Void)?
  
  var isFavorite: Bindable<Bool> = Bindable(false)
  
  // MARK: - Initializers
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       player: RadioPlayer?,
       station: StationRemote) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    
    self.stationSelected = station
    self.radioPlayer = player
    radioPlayer?.addObserver(self)
    
    setupRadio(with: stationSelected)
  }
  
  deinit {
    radioPlayer?.removeObserver(self)
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationRemote) {
    name = station.name
    image = URL(string: station.pathImage)
    checkIsFavorite(with: station)
  }
  
  // MARK: - Public
  
  func togglePlayPause() {
    guard let player = radioPlayer else { return }
    player.togglePlayPause()
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
  
  func markAsFavorite() {
    let simpleStation = SimpleStation(name: stationSelected.name, group: stationSelected.group)
    
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
}

// MARK: - RadioPlayerObserver

extension PlayerViewModel: RadioPlayerObserver {
  
  func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
    viewState.value = state
  }
  
  func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
    updateUI?()
  }
  
}
