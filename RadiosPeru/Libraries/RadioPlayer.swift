//
//  RadioPlayer.swift
//  RadiosPeru
//
//  Created by Jeans on 10/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

class RadioPlayer: RadioPlayerProtocol {
  
  private let showDetailsUseCase: FetchShowOnlineInfoUseCase
  
  private let saveStreamErrorUseCase: SaveStationStreamError
  
  private let savePlayingEventUseCase: SavePlayingEventUseCase
  
  private let player = ApiPlayer.shared
  
  private var dataSource: PlayerDataSource? {
    didSet {
      player.dataSource = dataSource
    }
  }
  
  private let onlineInfoBehaviorSubject: BehaviorSubject<String>
  
  private var disposeBag = DisposeBag()
  
  private let statePlayerBehaviorSubject: BehaviorSubject<RadioPlayerState>
  
  private let airingNowBehaviorSubject: BehaviorSubject<String>
  
  // MARK: - Public Api
  
  let statePlayer: Observable<RadioPlayerState>
  
  let airingNow: Observable<String>
  
  // MARK: - Initializers
  
  init(showDetailsUseCase: FetchShowOnlineInfoUseCase,
       saveStreamErrorUseCase: SaveStationStreamError,
       savePlayingEventUseCase: SavePlayingEventUseCase) {
    statePlayerBehaviorSubject = BehaviorSubject(value: .stopped)
    airingNowBehaviorSubject = BehaviorSubject(value: "")
    onlineInfoBehaviorSubject = BehaviorSubject(value: "")
    
    self.showDetailsUseCase = showDetailsUseCase
    self.saveStreamErrorUseCase = saveStreamErrorUseCase
    self.savePlayingEventUseCase = savePlayingEventUseCase
    
    statePlayer = statePlayerBehaviorSubject.asObservable()
    airingNow = airingNowBehaviorSubject.asObservable()
    
    player.delegate = self
  }
  
  // MARK: - Public
  
  func setupRadio(with station: StationRemote, playWhenReady: Bool = false) {
    statePlayerBehaviorSubject.onNext(.stopped)
    disposeBag = DisposeBag()
    
    resetRadio()
    
    trackPlayEvent(for: station)
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
        switch state {
        case .playing:
          self?.getAiringNowDetails(for: station)
        case .error(let error):
          self?.handleError(for: station, error: error)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func handleError(for station: StationRemote, error: String) {
    let event = Event(radioId: station.id,
                      radioName: station.name,
                      urlStream: station.urlStream,
                      description: error,
                      date: Date(),
                      uuid: UIDevice.current.identifierForVendor?.uuidString)
    let request = SaveStationErrorUseCaseRequestValue(event: event)
    
    saveStreamErrorUseCase.execute(requestValue: request)
      .subscribe(onNext: { id in
        print("save sucessfull: \(id)")
      }, onDisposed: {
        print("finish save_error")
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
  
  // MARK: - Log Events
  
  fileprivate func trackPlayEvent(for station: StationRemote) {
    statePlayerBehaviorSubject
      .distinctUntilChanged()
      .scan(EventPlay.empty, accumulator: { (old, new) -> EventPlay? in
        switch new {
        case .playing:
          return EventPlay(stationName: station.name, start: Date(), end: Date())
        case .stopped:
          guard let oldValue = old  else { return nil }
          return EventPlay(stationName: oldValue.stationName, start: oldValue.start, end: Date())
        case .error:
          guard let oldValue = old else { return nil }
          return EventPlay(stationName: oldValue.stationName, start: oldValue.start, end: Date())
        default:
          return nil
        }
      })
      .filter { if let event = $0, !event.stationName.isEmpty, event.seconds > 0 {
        return true
      } else {
        return false
        }
    }
    .map { [weak self] event -> Observable<Void> in
      guard let strongSelf = self, let event = event else { return Observable.just(()) }
      let request = SavePlayingEventUseCaseRequestValue(event: event)
      return strongSelf.savePlayingEventUseCase.execute(requestValue: request)
    }
    .subscribe(onNext: { _ in
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
