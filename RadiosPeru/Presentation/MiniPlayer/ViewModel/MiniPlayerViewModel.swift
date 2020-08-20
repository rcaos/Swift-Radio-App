//
//  MiniPlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol MiniPlayerViewModelDelegate: class {
  
  func stationPLayerDidSelect(station: StationProp)
}

protocol MiniPlayerViewModelProtocol {
  
  // MARK: - Input
  
  func showFullPlayer()
  
  func togglePlayPause()
  
  func markAsFavorite()
  
  func configStation(with: StationProp, playAutomatically: Bool)
  
  var delegate: MiniPlayerViewModelDelegate? { get set }
  
  // MARK: - Output
  
  var viewState: Observable<RadioPlayerState> { get }
  
  var isFavorite: Observable<Bool> { get }
  
  var stationName: Observable<String> { get }
  
  var stationDescription: Observable<String> { get }
}

final class MiniPlayerViewModel: MiniPlayerViewModelProtocol {
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private let askFavoriteUseCase: AskFavoriteUseCase
  
  private let favoritesChangedUseCase: FavoritesDidChangedUseCase
  
  private var radioPlayer: RadioPlayerProtocol?
  
  private var stationSelected: StationProp?
  
  private let viewStateBehaviorSubject = BehaviorSubject<RadioPlayerState>(value: .stopped)
  
  private let isFavoriteBehaviorSubject = BehaviorSubject<Bool>(value: false)
  
  private let stationNameBehaviorSubject = BehaviorSubject<String>(value: "Pick a Radio Station")
  
  private let stationDescriptionBehaviorSubject = BehaviorSubject<String>(value: "")
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Public Api
  
  let viewState: Observable<RadioPlayerState>
  
  let isFavorite: Observable<Bool>
  
  let stationName: Observable<String>
  
  let stationDescription: Observable<String>
  
  weak var delegate: MiniPlayerViewModelDelegate?
  
  // MARK: - Initializer
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       favoritesChangedUseCase: FavoritesDidChangedUseCase,
       player: RadioPlayerProtocol?,
       delegate: MiniPlayerViewModelDelegate? = nil) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    self.favoritesChangedUseCase = favoritesChangedUseCase
    
    self.delegate = delegate
    
    viewState = viewStateBehaviorSubject.asObservable()
    isFavorite = isFavoriteBehaviorSubject.asObservable()
    stationName = stationNameBehaviorSubject.asObservable()
    stationDescription = stationDescriptionBehaviorSubject.asObservable()
    
    radioPlayer = player
  }
  
  // MARK: - Public
  
  func configStation(with station: StationProp, playAutomatically: Bool = true) {
    if checkIsPlaying(with: station) { return }
    
    disposeBag = DisposeBag()
    
    stationSelected = station
    
    viewStateBehaviorSubject.onNext(.stopped)
    radioPlayer?.setupRadio(with: station, playWhenReady: playAutomatically)
    
    setupRadio(with: station)
    subscribeToFavoriteChanges(for: station)
    subscribe(to: radioPlayer)
  }
  
  fileprivate func subscribe(to radioPlayer: RadioPlayerProtocol?) {
    guard let radioPlayer = radioPlayer else { return }
    
    radioPlayer.statePlayer
      .bind(to: viewStateBehaviorSubject)
      .disposed(by: disposeBag)
    
    radioPlayer.airingNow
      .bind(to: stationDescriptionBehaviorSubject)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Public Input Api
  
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
  
  fileprivate func setupRadio(with station: StationProp) {
    stationNameBehaviorSubject.onNext(station.name)
  }
  
  fileprivate func subscribeToFavoriteChanges(for station: StationProp) {
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
  
  fileprivate func checkIsPlaying(with station: StationProp) -> Bool {
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
}
