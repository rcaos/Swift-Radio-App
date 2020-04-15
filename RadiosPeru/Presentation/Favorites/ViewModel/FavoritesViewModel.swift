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
  
  private var favoritesRepository: FavoritesRepository
  
  private var stations: [StationRemote] = []
  
  var favoriteCells: [PopularCellViewModel] = []
  
  var viewState: Bindable<ViewState> = Bindable(.empty)
  
  private weak var delegate: FavoritesViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(fetchFavoritesUseCase: FetchFavoritesStationsUseCase,
       favoritesRepository: FavoritesRepository,
       delegate: FavoritesViewModelDelegate? = nil) {
    self.fetchFavoritesUseCase = fetchFavoritesUseCase
    self.delegate = delegate
    self.favoritesRepository = favoritesRepository
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
    stations = items
    
    favoriteCells = items.map({
      PopularCellViewModel(station: $0)
    })
    
    if favoriteCells.isEmpty {
      viewState.value = .empty
    } else {
      viewState.value = .populated
    }
  }
  
  // MARK: - Public Methods
  
  func getStationSelection(by index: Int) {
    delegate?.stationFavoriteDidSelect(station: stations[index])
  }
}

extension FavoritesViewModel {
  
  enum ViewState {
    
    case populated
    case empty
    
  }
}
