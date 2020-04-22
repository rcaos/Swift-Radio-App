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
  
  weak var delegate: MiniPlayerViewModelDelegate?
  
  private let viewStateBehaviorSubject = BehaviorSubject<RadioPlayerState>(value: .stopped)
  private let isFavoriteBehaviorSubject = BehaviorSubject<Bool>(value: false)
  private let stationNameBehaviorSubject = BehaviorSubject<String>(value: "Pick a Radio Station")
  private let stationDescriptionBehaviorSubject = BehaviorSubject<String>(value: "")
  
  private var disposeBag = DisposeBag()
  
  public var input: Input
  
  public var output: Output
  
  // MARK: - Initializers
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       favoritesChangedUseCase: FavoritesDidChangedUseCase,
       player: RadioPlayer?,
       delegate: MiniPlayerViewModelDelegate? = nil) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    self.favoritesChangedUseCase = favoritesChangedUseCase
    
    self.delegate = delegate
    
    self.input = Input()
    self.output = Output(viewState: viewStateBehaviorSubject.asObservable(),
                         isFavorite: isFavoriteBehaviorSubject.asObservable(),
                         stationName: stationNameBehaviorSubject.asObservable(),
                         stationDescription: stationDescriptionBehaviorSubject.asObservable())
    radioPlayer = player
    radioPlayer?.addObserver(self)
  }
  
  deinit {
    radioPlayer?.removeObserver(self)
  }
  
  // MARK: - Public
  
  func configStation(with station: StationRemote, playAutomatically: Bool = true) {
    if checkIsPlaying(with: station) { return }
    
    disposeBag = DisposeBag()
    
    stationSelected = station
    
    viewStateBehaviorSubject.onNext(.stopped)
    radioPlayer?.setupRadio(with: station, playWhenReady: playAutomatically)
    
    setupRadio(with: station)
    subscribeToFavoriteChanges(for: station)
  }
  
  func showFullPlayer() {
    guard let selected = stationSelected else { return }
    delegate?.stationPLayerDidSelect(station: selected)
  }
  
  func markAsFavorite() {
    guard let selected = stationSelected else { return }
    
    let simpleStation = SimpleStation(name: selected.name, id: selected.id)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
  }
  
  func togglePlayPause() {
    guard let player = radioPlayer,
      stationSelected != nil else { return }
    player.togglePlayPause()
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationRemote) {
    stationNameBehaviorSubject.onNext(station.name)
    stationDescriptionBehaviorSubject.onNext(getPlayerDescription())
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
      strongSelf.isFavoriteBehaviorSubject.onNext(isFavorite)
    })
      .disposed(by: disposeBag)
  }
  
  // MARK: - TODO, Model with operatos instead u.u
  
  fileprivate func checkIsPlaying(with station: StationRemote) -> Bool {
    if stationSelected == station,
      let state = try? viewStateBehaviorSubject.value() {
      switch state {
      case .buffering, .loading, .playing:
        return true
      default:
        return false
      }
    } else {
      return false
    }
  }
  
  fileprivate func getPlayerDescription() -> String {
    guard let radioPlayer = radioPlayer else { return ""}
    return radioPlayer.getRadioDescription()
  }
}

// MARK: - RadioPlayerObserver

extension MiniPlayerViewModel: RadioPlayerObserver {
  
  func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
    viewStateBehaviorSubject.onNext(state)
  }
  
  func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
    stationDescriptionBehaviorSubject.onNext(getPlayerDescription())
  }
}

extension MiniPlayerViewModel {
  
  public struct Input { }
  
  public struct Output {
    
    let viewState: Observable<RadioPlayerState>
    
    let isFavorite: Observable<Bool>
    
    let stationName: Observable<String>
    
    let stationDescription: Observable<String>
  }
}
