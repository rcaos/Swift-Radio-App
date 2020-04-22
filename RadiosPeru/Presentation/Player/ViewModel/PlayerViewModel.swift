//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

final class PlayerViewModel {
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private let askFavoriteUseCase: AskFavoriteUseCase
  
  private var radioPlayer: RadioPlayer?
  
  private var stationSelected: StationRemote
  
  private let viewStateBehaviorSubject = BehaviorSubject<RadioPlayerState>(value: .stopped)
  private let isFavoriteBehaviorSubject = BehaviorSubject<Bool>(value: false)
  private let stationNameBehaviorSubject = BehaviorSubject<String>(value: "Pick a Radio Station")
  private let stationDescriptionBehaviorSubject = BehaviorSubject<String>(value: "")
  private let stationURLBehaviorSubject = BehaviorSubject<URL?>(value: nil)
  
  private let disposeBag = DisposeBag()
  
  public var input: Input
  
  public var output: Output
  
  // MARK: - Initializers
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       player: RadioPlayer?,
       station: StationRemote) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    
    self.stationSelected = station
    self.radioPlayer = player
    
    self.input = Input()
    self.output = Output(viewState: viewStateBehaviorSubject.asObservable(),
                         isFavorite: isFavoriteBehaviorSubject.asObservable(),
                         stationName: stationNameBehaviorSubject.asObservable(),
                         stationDescription: stationDescriptionBehaviorSubject.asObservable(),
                         stationURL: stationURLBehaviorSubject.asObservable())
    
    radioPlayer?.addObserver(self)
    
    setupRadio(with: stationSelected)
  }
  
  deinit {
    radioPlayer?.removeObserver(self)
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationRemote) {
    stationNameBehaviorSubject.onNext(station.name)
    stationURLBehaviorSubject.onNext( URL(string: station.pathImage))
    checkIsFavorite(with: station)
    stationDescriptionBehaviorSubject.onNext( getPlayerDescription() )
  }
  
  // MARK: - Public
  
  func viewDidLoad() {
    guard let player = radioPlayer else { return }
    viewStateBehaviorSubject.onNext(player.state)
    
    viewStateBehaviorSubject
      .subscribe(onNext: { [player] state in
        if case .playing = state {
          player.refreshOnlineInfo()
        }
      })
      .disposed(by: disposeBag)
  }
  
  func togglePlayPause() {
    guard let player = radioPlayer else { return }
    player.togglePlayPause()
  }
  
  func markAsFavorite() {
    let simpleStation = SimpleStation(name: stationSelected.name, id: stationSelected.id)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] isFavorite in
        guard let strongSelf = self else { return }
        strongSelf.isFavoriteBehaviorSubject.onNext(isFavorite)
      })
      .disposed(by: disposeBag)
  }
  
  private func checkIsFavorite(with station: StationRemote?) {
    guard let station = station else { return  }
    
    let simpleStation = SimpleStation(name: station.name, id: station.id)
    let request = AskFavoriteUseCaseRequestValue(station: simpleStation)
    
    askFavoriteUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] isFavorite in
        guard let strongSelf = self else { return }
        strongSelf.isFavoriteBehaviorSubject.onNext(isFavorite)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func getPlayerDescription() -> String {
    guard let radioPlayer = radioPlayer else { return ""}
    return radioPlayer.getRadioDescription()
  }
}

// MARK: - RadioPlayerObserver

extension PlayerViewModel: RadioPlayerObserver {
  
  func radioPlayer(_ radioPlayer: RadioPlayer, didChangeState state: RadioPlayerState) {
    viewStateBehaviorSubject.onNext(state)
  }
  
  func radioPlayerDidChangeOnlineInfo(_ radioPlayer: RadioPlayer) {
    stationDescriptionBehaviorSubject.onNext( getPlayerDescription() )
  }
}

extension PlayerViewModel {
  
  public struct Input { }
  
  public struct Output {
    
    let viewState: Observable<RadioPlayerState>
    
    let isFavorite: Observable<Bool>
    
    let stationName: Observable<String>
    
    let stationDescription: Observable<String>
    
    let stationURL: Observable<URL?>
  }
}
