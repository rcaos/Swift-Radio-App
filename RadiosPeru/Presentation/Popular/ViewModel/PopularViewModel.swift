//
//  PopularViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

protocol PopularViewModelDelegate: class {
  
  func stationDidSelect(station: StationRemote)
}

final class PopularViewModel {
  
  private let fetchStationsUseCase: FetchStationsLocalUseCase
  
  private var stations: [StationRemote] = []
  
  var popularCells: [PopularCellViewModel] = []
  
  var viewState: Bindable<ViewState> = Bindable(.empty)
  
  private weak var delegate: PopularViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  init(fetchStationsUseCase: FetchStationsLocalUseCase, delegate: PopularViewModelDelegate? = nil) {
    self.fetchStationsUseCase = fetchStationsUseCase
    self.delegate = delegate
  }
  
  func getStations() {
    let request = FetchStationsLocalUseCaseRequestValue()
    
    fetchStationsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] entities in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: entities)
      })
      .disposed(by: disposeBag)
  }
  
  private func processFetched(for items: [StationRemote]) {
    stations = items
    
    popularCells = stations.map({
      PopularCellViewModel(station: $0)
    })
    
    if popularCells.isEmpty {
      viewState.value = .empty
    } else {
      viewState.value = .populated
    }
  }
  
  func getStationSelection(by index: Int) {
    delegate?.stationDidSelect(station: stations[index])
  }
}

extension PopularViewModel {
  
  enum ViewState {
    
    case populated
    case empty
    
  }
}
