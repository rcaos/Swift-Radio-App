//
//  MainViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol MainViewModelProtocol: MiniPlayerViewModelDelegate, PopularViewModelDelegate, FavoritesViewModelDelegate {
  
  var miniPlayerViewModel: MiniPlayerViewModel { get }
  
  var showMiniPlayer: (() -> Void)? { get set }
  
  var showSettingsSubject: PublishSubject<Void> { get }
}

final class MainViewModel: MainViewModelProtocol {
  
  let miniPlayerViewModel: MiniPlayerViewModel // why? , find better way ?
  
  var showMiniPlayer: (() -> Void)?
  
  let showSettingsSubject = PublishSubject<Void>()
  
  weak var coordinator: MainCoordinatorProtocol?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(miniPlayerViewModel: MiniPlayerViewModel) {
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
  
  func selectStation(with station: StationRemote) {
    miniPlayerViewModel.configStation(with: station)
    showMiniPlayer?()
  }
  
  // MARK: - Navigation
  
  func navigate(to step: MainSteps) {
    coordinator?.navigate(to: step)
  }
}

// MARK: - PopularViewModelDelegate

extension MainViewModel: PopularViewModelDelegate {
  
  func stationDidSelect(station: StationRemote) {
    selectStation(with: station)
  }
}

// MARK: - FavoritesViewModelDelegate

extension MainViewModel: FavoritesViewModelDelegate {
  
  func stationFavoriteDidSelect(station: StationRemote) {
    selectStation(with: station)
  }
}

// MARK: - MiniPlayerViewModelDelegate

extension MainViewModel: MiniPlayerViewModelDelegate {
  
  func stationPLayerDidSelect(station: StationRemote) {
    navigate(to: .miniPlayerDidSelected(station: station))
  }
}
