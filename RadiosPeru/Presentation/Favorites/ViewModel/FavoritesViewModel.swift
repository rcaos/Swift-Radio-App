//
//  FavoritesViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol FavoritesViewModelDelegate: class {
  
  func stationFavoriteDidSelect(station: StationRemote)
}

final class FavoritesViewModel {
  
  private let fetchFavoritesUseCase: FetchFavoritesStationsUseCase
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private var viewStateSubject = BehaviorSubject<SimpleViewState<FavoriteTableViewModel>>(value: .loading)
  
  private weak var delegate: FavoritesViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  public let input: Input
  
  public let output: Output
  
  // MARK: - Initializers
  
  init(fetchFavoritesUseCase: FetchFavoritesStationsUseCase,
       toggleFavoritesUseCase: ToggleFavoritesUseCase,
       delegate: FavoritesViewModelDelegate? = nil) {
    self.fetchFavoritesUseCase = fetchFavoritesUseCase
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.delegate = delegate
    
    input = Input()
    output = Output(viewState: viewStateSubject.asObservable())
  }
  
  func getStations() {
    let request = FetchFavoritesStationsRequestValue()
    
    fetchFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] items in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: items)
      })
      .disposed(by: disposeBag)
  }
  
  private func processFetched(for items: [StationRemote]) {
    let cells = items.map( FavoriteTableViewModel.init )
    
    if cells.isEmpty {
      viewStateSubject.onNext( .empty )
    } else {
      viewStateSubject.onNext( .populated(cells) )
    }
  }
  
  // MARK: - Public Methods
  
  func stationDidSelected(with station: StationRemote) {
    delegate?.stationFavoriteDidSelect(station: station)
  }
  
  func favoriteDidSelect(for station: StationRemote) {
    let simpleStation = SimpleStation(name: station.name, group: station.group)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { _ in
      })
      .disposed(by: disposeBag)
  }
}

extension FavoritesViewModel {
  
  struct Input {}
  
  struct Output {
    let viewState: Observable<SimpleViewState<FavoriteTableViewModel>>
  }
}
