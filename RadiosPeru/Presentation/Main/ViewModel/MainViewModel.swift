//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum MainViewModelRoute {
  case initial
  case showPlayer(StationRemote)
  case showSettings
}

final class MainViewModel {
  
  var miniPlayer: MiniPlayerViewModel
  
  var radioPlayer: RadioPlayer
  
  var route: Bindable<MainViewModelRoute> = Bindable(.initial)
  
  init(radioPlayer: RadioPlayer, miniPlayerViewModel: MiniPlayerViewModel) {
    self.radioPlayer = radioPlayer
    
    miniPlayer = miniPlayerViewModel
  }
  
  func selectStation(with station: StationRemote) {
    miniPlayer.configStation(with: station)
  }
}

extension MainViewModel: PopularViewModelDelegate {
  
  func stationDidSelect(station: StationRemote) {
    selectStation(with: station)
  }
}

extension MainViewModel: FavoritesViewModelDelegate {
  
  func stationFavoriteDidSelect(station: StationRemote) {
    selectStation(with: station)
  }
}

extension MainViewModel: MiniPlayerViewModelDelegate {
  
  func stationPLayerDidSelect(station: StationRemote) {
    route.value = .showPlayer(station)
  }
}
