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
  
  private let favoritesChangedUseCase: FavoritesDidChangedUseCase
  
  private var radioPlayer: RadioPlayer?
  
  private var stationSelected: StationRemote?
  
  var name: String = "Pick a Radio Station"
  
  weak var delegate: MiniPlayerViewModelDelegate?
  
  var viewState: Bindable<RadioPlayerState> = Bindable(.stopped)
  
  var updateUI: (() -> Void)?
  
  var isFavorite: Bindable<Bool> = Bindable(false)
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       favoritesChangedUseCase: FavoritesDidChangedUseCase,
       player: RadioPlayer?,
       delegate: MiniPlayerViewModelDelegate? = nil) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    self.favoritesChangedUseCase = favoritesChangedUseCase
    
    radioPlayer = player
    radioPlayer?.addObserver(self)
    self.delegate = delegate
  }
  
  deinit {
    radioPlayer?.removeObserver(self)
  }
  
  // MARK: - Public
  
  func configStation(with station: StationRemote, playAutomatically: Bool = true) {
    if checkIsPlaying(with: station) { return }
  
    disposeBag = DisposeBag()
    
    stationSelected = station
    
    setupRadio(with: station)
    subscribeToFavoriteChanges(for: station)
    
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
    
    let simpleStation = SimpleStation(name: selected.name, id: selected.id)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationRemote) {
    self.name = station.name
  }
  
  private func subscribeToFavoriteChanges(for station: StationRemote) {
    favoritesChangedUseCase.execute(requestValue: FavoritesDidChangedUseCaseRequestValue() )
      .flatMap { () -> Observable<Bool> in
        let simpleStation = SimpleStation(name: station.name, id: station.id)
        let request = AskFavoriteUseCaseRequestValue(station: simpleStation)
        return self.askFavoriteUseCase.execute(requestValue: request)
    }
    .subscribe(onNext: { [weak self] isFavorite in
      guard let strongSelf = self else { return }
      strongSelf.isFavorite.value = isFavorite
    })
      .disposed(by: disposeBag)
  }
  
  fileprivate func checkIsPlaying(with station: StationRemote) -> Bool {
    if stationSelected == station {
      switch viewState.value {
      case .buffering, .loading, .playing:
        return true
      default:
        return false
      }
    } else {
      return false
    }
  }
  
  // MARK: - Public
  
  func showPlayer() {
    guard let selected = stationSelected else { return }
    delegate?.stationPLayerDidSelect(station: selected)
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
