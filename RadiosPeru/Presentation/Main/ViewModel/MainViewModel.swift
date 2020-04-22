//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

enum MainViewModelRoute {
  case initial
  case showPlayer(StationRemote)
  case showSettings
}

final class MainViewModel {
  
  var miniPlayer: MiniPlayerViewModel
  
  var radioPlayer: RadioPlayer
  
  private let routeBehaviorSubject = BehaviorSubject<MainViewModelRoute>(value: .initial)
  
  var showMiniPlayer: (() -> Void)?
  
  let disposeBag = DisposeBag()
  
  public var input: Input
  
  public var output: Output
  
  // MARK: - Initializers
  
  init(radioPlayer: RadioPlayer, miniPlayerViewModel: MiniPlayerViewModel) {
    self.radioPlayer = radioPlayer
    
    miniPlayer = miniPlayerViewModel
    
    input = Input()
    output = Output(route: routeBehaviorSubject.asObservable())
    
    subscribe()
  }
  
  func subscribe() {
    input.showSettings
      .map { return .showSettings }
      .bind(to: routeBehaviorSubject )
      .disposed(by: disposeBag)
  }
  
  func selectStation(with station: StationRemote) {
    miniPlayer.configStation(with: station)
    showMiniPlayer?()
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
    routeBehaviorSubject.onNext( .showPlayer(station) )
  }
}

extension MainViewModel {
  
  public struct Input {
    let showSettings = PublishSubject<Void>()
  }
  
  public struct Output {
    let route: Observable<MainViewModelRoute>
  }
}
