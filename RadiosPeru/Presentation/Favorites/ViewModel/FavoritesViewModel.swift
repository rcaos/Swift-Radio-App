//
//  FavoritesViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

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
  
  init(fetchFavoritesUseCase: FetchFavoritesStationsUseCase,
       favoritesRepository: FavoritesRepository,
       delegate: FavoritesViewModelDelegate? = nil) {
    self.fetchFavoritesUseCase = fetchFavoritesUseCase
    self.delegate = delegate
    self.favoritesRepository = favoritesRepository
  }
  
  func suscribe() {
    favoritesRepository.configStore()
    favoritesRepository.delegate = self
  }
  
  func getStations() {
    let request = FetchFavoritesStationsRequestValue()
    
    _ = fetchFavoritesUseCase.execute(requestValue: request) { [weak self] result in
      switch result {
      case .success(let items):
        self?.processFetched(for: items)
      case .failure:
        break
      }
      
      self?.suscribe()
    }
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

// MARK: - PersistenceStoreDelegate

extension FavoritesViewModel: FavoritesRepositoryDelegate {
  
  func stationsLocalRepository(didUpdateEntity update: Bool) {
    getStations()
  }
}

extension FavoritesViewModel {
  
  enum ViewState {
    
    case populated
    case empty
    
  }
}
