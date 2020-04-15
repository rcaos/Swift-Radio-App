//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

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
  
  var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
  
  var updateUI:(() -> Void)?
  
  var isFavorite: Bindable<Bool> = Bindable(false)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
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
  
  // MARK: - Public
  
  func configStation(with station: StationRemote, playAutomatically: Bool = true) {
    stationSelected = station
    
    setupRadio(with: station)
    checkIsFavorite(with: station)
    
    viewState.value = .stopped
    radioPlayer?.setupRadio(with: station, playWhenReady: playAutomatically)
  }
  
  func togglePlayPause() {
    guard let player = radioPlayer,
      stationSelected != nil else { return }
    player.togglePlayPause()
  }
  
  func markAsFavorite() {
    guard let selected = stationSelected else { return }
    
    let simpleStation = SimpleStation(name: selected.name, group: selected.group)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] isFavorite in
        guard let strongSelf = self else { return }
        strongSelf.isFavorite.value = isFavorite
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationRemote) {
    self.name = station.name
  }
  
  private func checkIsFavorite(with station: StationRemote?) {
    print("checkIsFavorite")
    isFavorite.value = false
    
    guard let station = station else { return  }
    
    let simpleStation = SimpleStation(name: station.name, group: station.group)
    let request = AskFavoriteUseCaseRequestValue(station: simpleStation)
    
    askFavoriteUseCase.execute(requestValue: request)
      .subscribe(onNext: {[weak self] isFavorite in
        guard let strongSelf = self else { return }
        strongSelf.isFavorite.value = isFavorite
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Public
  
  func showPlayer() {
    guard let selected = stationSelected else { return }
    delegate?.stationPLayerDidSelect(station: selected)
  }
  
  func viewWillAppear() {
    checkIsFavorite(with: stationSelected)
  }
  
  func getDescription() -> String {
    guard let radioPlayer = radioPlayer else { return "" }
    
    return radioPlayer.getRadioDescription()
  }
}

// MARK: - RadioPlayerObserver

extension MiniPlayerViewModel: RadioPlayerObserver {
  
  func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
    viewState.value = state
  }
  
  func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
    updateUI?()
  }
  
}
