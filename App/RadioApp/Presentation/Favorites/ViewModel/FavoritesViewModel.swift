//
//  FavoritesViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Domain
import RxSwift

protocol FavoritesViewModelDelegate: class {
  
  func stationFavoriteDidSelect(station: StationProp)
}

protocol FavoritesViewModelProtocol {
  
  // MARK: - Input
  
  func viewDidLoad()
  
  func stationDidSelected(with: StationProp)
  
  func favoriteDidSelect(for: StationProp)
  
  // MARK: - Output
  
  var viewState: Observable<SimpleViewState<FavoriteTableViewModel>> { get }
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
  
  private let fetchFavoritesUseCase: FetchFavoritesStationsUseCase
  
  private let toggleFavoritesUseCase: ToggleFavoritesUseCase
  
  private var viewStateSubject = BehaviorSubject<SimpleViewState<FavoriteTableViewModel>>(value: .loading)
  
  private weak var delegate: FavoritesViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public APi
  
  let viewState: Observable<SimpleViewState<FavoriteTableViewModel>>
  
  // MARK: - Initializers
  
  init(fetchFavoritesUseCase: FetchFavoritesStationsUseCase,
       toggleFavoritesUseCase: ToggleFavoritesUseCase,
       delegate: FavoritesViewModelDelegate? = nil) {
    self.fetchFavoritesUseCase = fetchFavoritesUseCase
    self.toggleFavoritesUseCase = toggleFavoritesUseCase
    self.delegate = delegate
    
    viewState = viewStateSubject.asObservable()
  }
  
  // MARK: - Public Api
  
  func viewDidLoad() {
    let request = FetchFavoritesStationsRequestValue()
    
    fetchFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] items in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: items)
      })
      .disposed(by: disposeBag)
  }
  
  func stationDidSelected(with station: StationProp) {
    delegate?.stationFavoriteDidSelect(station: station)
  }
  
  func favoriteDidSelect(for station: StationProp) {
    let simpleStation = SimpleStation(name: station.name, id: station.id)
    
    let request = ToggleFavoriteUseCaseRequestValue(station: simpleStation)
    
    toggleFavoritesUseCase.execute(requestValue: request)
      .subscribe(onNext: { _ in
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private
  
  fileprivate func processFetched(for items: [StationRemote]) {
    let cells = items
      .map { StationProp($0) }
      .map { FavoriteTableViewModel($0) }
    
    if cells.isEmpty {
      viewStateSubject.onNext( .empty )
    } else {
      viewStateSubject.onNext( .populated(cells) )
    }
  }
}
