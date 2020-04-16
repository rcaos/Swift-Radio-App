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
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<PopularCellViewModel>>(value: .empty)
  
  private weak var delegate: PopularViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  public var input: Input
  
  public var output: Output
  
  // MARK: - Initializers
  
  init(fetchStationsUseCase: FetchStationsLocalUseCase, delegate: PopularViewModelDelegate? = nil) {
    self.fetchStationsUseCase = fetchStationsUseCase
    self.delegate = delegate
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
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
    let popularCells = items.map( PopularCellViewModel.init )
    
    if popularCells.isEmpty {
      viewStateObservableSubject.onNext(.empty)
    } else {
      viewStateObservableSubject.onNext(.populated(popularCells))
    }
  }
  
  func stationDidSelect(with station: StationRemote) {
    delegate?.stationDidSelect(station: station)
  }
}

extension PopularViewModel {
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<PopularCellViewModel>>
  }
}
