//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol MainViewModelProtocol: MiniPlayerViewModelDelegate, PopularViewModelDelegate, FavoritesViewModelDelegate {
  
  var miniPlayerViewModel: MiniPlayerViewModelProtocol? { get set }
  
  var showMiniPlayer: (() -> Void)? { get set }
  
  var showSettingsSubject: PublishSubject<Void> { get }
  
  var coordinator: MainCoordinatorProtocol? { get set }
}

final class MainViewModel: MainViewModelProtocol {
  
  var miniPlayerViewModel: MiniPlayerViewModelProtocol?
  
  var showMiniPlayer: (() -> Void)?
  
  let showSettingsSubject = PublishSubject<Void>()
  
  weak var coordinator: MainCoordinatorProtocol?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(miniPlayerViewModel: MiniPlayerViewModelProtocol? = nil) {
    self.miniPlayerViewModel = miniPlayerViewModel
    subscribe()
  }
  
  func subscribe() {
    showSettingsSubject
      .subscribe(onNext: { [weak self] in
        self?.navigate(to: .settingsIsRequired)
      })
      .disposed(by: disposeBag)
  }
  
  func selectStation(with station: StationProp) {
    miniPlayerViewModel?.configStation(with: station, playAutomatically: true)
    showMiniPlayer?()
  }
  
  // MARK: - Navigation
  
  func navigate(to step: MainSteps) {
    coordinator?.navigate(to: step)
  }
}

// MARK: - PopularViewModelDelegate

extension MainViewModel: PopularViewModelDelegate {
  
  func stationDidSelect(station: StationProp) {
    selectStation(with: station)
  }
}

// MARK: - FavoritesViewModelDelegate

extension MainViewModel: FavoritesViewModelDelegate {
  
  func stationFavoriteDidSelect(station: StationProp) {
    selectStation(with: station)
  }
}

// MARK: - MiniPlayerViewModelDelegate

extension MainViewModel: MiniPlayerViewModelDelegate {
  
  func stationPLayerDidSelect(station: StationProp) {
    navigate(to: .miniPlayerDidSelected(station: station))
  }
}
