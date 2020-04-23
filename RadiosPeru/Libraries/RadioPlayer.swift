//
//  RadioPlayer.swift
//  RadiosPeru
//
//  Created by Jeans on 10/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

// MARK: - Visual States

enum RadioPlayerState {
  
  case stopped
  case loading
  case playing
  case buffering
  case error(String)
}

class RadioPlayer {
  
  private let showDetailsUseCase: FetchShowOnlineInfoUseCase
  
  private let player = ApiPlayer.shared
  
  private var dataSource: PlayerDataSource? {
    didSet {
      player.dataSource = dataSource
    }
  }
  
  private let onlineInfoBehaviorSubject: BehaviorSubject<String>
  
  private var disposeBag = DisposeBag()
  
  public let statePlayerBehaviorSubject: BehaviorSubject<RadioPlayerState>
  
  public let airingNowBehaviorSubject: BehaviorSubject<String>
  
  // MARK: - Initializers
  
  init(showDetailsUseCase: FetchShowOnlineInfoUseCase) {
    statePlayerBehaviorSubject = BehaviorSubject(value: .stopped)
    airingNowBehaviorSubject = BehaviorSubject(value: "")
    onlineInfoBehaviorSubject = BehaviorSubject(value: "")
    
    self.showDetailsUseCase = showDetailsUseCase
    player.delegate = self
  }
  
  // MARK: - Public
  
  func setupRadio(with station: StationRemote, playWhenReady: Bool = false) {
    disposeBag = DisposeBag()
    
    resetRadio()
    
    subscribeToState(for: station)
    subscribeToDescription(for: station)
    bindToRemoteControls(for: station)
    
    if let url = URL(string: station.urlStream) {
      player.prepare(with: url, playWhenReady: playWhenReady)
    }
  }
  
  func togglePlayPause() {
    player.togglePlayPause()
  }
  
  // MARK: - Private
  
  fileprivate func resetRadio() {
    player.stop()
    onlineInfoBehaviorSubject.onNext("")
  }
  
  fileprivate func subscribeToState(for station: StationRemote) {
    statePlayerBehaviorSubject
      .subscribe(onNext: { [weak self] state in
        if case .playing = state {
          self?.getAiringNowDetails(for: station)
        }
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func subscribeToDescription(for station: StationRemote) {
    Observable.combineLatest( statePlayerBehaviorSubject, onlineInfoBehaviorSubject)
      .flatMap { [weak self] (state, onlineInfo) -> Observable<String> in
        guard let strongSelf = self else { return Observable.just("") }
        return Observable.just(
          strongSelf.buildDescription(for: state, station: station, onlineInfo))
    }
    .bind(to: airingNowBehaviorSubject)
    .disposed(by: disposeBag)
  }
  
  fileprivate func bindToRemoteControls(for station: StationRemote) {
    let defaultInfo = station.city + " - " +
      station.frecuency + " - " +
      station.slogan
    
    onlineInfoBehaviorSubject
      .subscribe(onNext: { [weak self] onlineInfo in
        self?.dataSource = PlayerDataSource(title: station.name,
                                            defaultInfo: defaultInfo,
                                            onlineNowInfo: onlineInfo,
                                            artWork: station.pathImage)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func buildDescription(for state: RadioPlayerState,
                                    station: StationRemote,
                                    _ onlineInfo: String) -> String {
    let defaultDescription =
      station.city + " - " +
        station.frecuency + " - " +
        station.slogan
    
    var onLineDescription = defaultDescription
    
    if !onlineInfo.isEmpty {
      onLineDescription =
        station.city + " - " +
        station.frecuency + " - " +
      onlineInfo
    }
    
    switch state {
    case .playing, .buffering:
      return onLineDescription
    case .error(let message):
      return message
    default:
      return defaultDescription
    }
  }
  
  // MARK: - Networking
  
  private func getAiringNowDetails(for station: StationRemote) {
    let request = FetchShowOnlineInfoUseCaseRequestValue(group: station.type)
    
    showDetailsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] showDetail in
        guard let strongSelf = self else { return }
        strongSelf.onlineInfoBehaviorSubject.onNext(showDetail.name)
        
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          print("Error to get online Description: \(error)")
          strongSelf.onlineInfoBehaviorSubject.onNext("")
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - ApiPlayerDelegate

extension RadioPlayer: ApiPlayerDelegate {
  
  func apiPlayerDelegate(didChangeState state: ApiPlayerState) {
    statePlayerBehaviorSubject.onNext( mapState(with: state) )
  }
  
  fileprivate func mapState(with state: ApiPlayerState) -> RadioPlayerState {
    let radioState: RadioPlayerState
    
    switch state {
    case .playing :
      radioState = .playing
    case .buffering :
      radioState = .buffering
    case .preparing :
      radioState = .loading
    case .error :
      radioState = .error("Error: Try another Radio")
    default :
      radioState = .stopped
    }
    
    return radioState
  }
}
