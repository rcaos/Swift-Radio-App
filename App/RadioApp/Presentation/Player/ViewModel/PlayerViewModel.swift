//
//  PlayerViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Domain
import RadioPlayer
import Foundation
import RxSwift

protocol PlayerViewModelProtocol {
  
  // MARK: - Input
  
  func togglePlayPause()
  
  func markAsFavorite()
  
  // MARK: - Output
  var viewState: Observable<RadioPlayerState> { get }
  
  var isFavorite: Observable<Bool> { get }
  
  var stationName: Observable<String> { get }
  
  var stationDescription: Observable<String> { get }
  
  var stationURL: Observable<URL?> { get }
}

final class PlayerViewModel: PlayerViewModelProtocol {
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private let askFavoriteUseCase: AskFavoriteUseCase
  
  private var radioPlayer: RadioPlayerProtocol?
  
  private var stationSelected: StationProp
  
  private let viewStateBehaviorSubject = BehaviorSubject<RadioPlayerState>(value: .stopped)
  
  private let isFavoriteBehaviorSubject = BehaviorSubject<Bool>(value: false)
  
  private let stationNameBehaviorSubject = BehaviorSubject<String>(value: "Pick a Radio Station")
  
  private let stationDescriptionBehaviorSubject = BehaviorSubject<String>(value: "")
  
  private let stationURLBehaviorSubject = BehaviorSubject<URL?>(value: nil)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public Api
  
  let viewState: Observable<RadioPlayerState>
  
  let isFavorite: Observable<Bool>
  
  let stationName: Observable<String>
  
  let stationDescription: Observable<String>
  
  let stationURL: Observable<URL?>
  
  // MARK: - Initializers
  
  init(toggleFavoritesUseCase: ToggleFavoritesUseCase,
       askFavoriteUseCase: AskFavoriteUseCase,
       player: RadioPlayerProtocol?,
       station: StationProp) {
    
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.askFavoriteUseCase = askFavoriteUseCase
    
    stationSelected = station
    radioPlayer = player
    
    viewState = viewStateBehaviorSubject.asObservable()
    isFavorite = isFavoriteBehaviorSubject.asObservable()
    stationName = stationNameBehaviorSubject.asObservable()
    stationDescription = stationDescriptionBehaviorSubject.asObservable()
    stationURL = stationURLBehaviorSubject.asObservable()
    
    setupRadio(with: stationSelected)
  }
  
  // MARK: - Private
  
  private func setupRadio(with station: StationProp) {
    stationNameBehaviorSubject.onNext(station.name)
    stationURLBehaviorSubject.onNext( URL(string: station.pathImage))
    checkIsFavorite(with: station)
    subscribe(to: radioPlayer)
  }
  
  private func subscribe(to radioPlayer: RadioPlayerProtocol?) {
    guard let radioPlayer = radioPlayer else {
      return
    }

    radioPlayer.statePlayer
      .subscribe { event in
        self.viewStateBehaviorSubject.on(event)
      }
      .disposed(by: disposeBag)

    radioPlayer.airingNow
      .subscribe { event in
        self.stationDescriptionBehaviorSubject.on(event)
      }
      .disposed(by: disposeBag)
  }
  
  private func checkIsFavorite(with station: StationProp?) {
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
  
  // MARK: - Public Api
  
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
}
