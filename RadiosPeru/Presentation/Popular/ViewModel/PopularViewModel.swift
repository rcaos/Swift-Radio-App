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

protocol PopularViewModelProtocol {
  
  // MARK: - Input
  
  func viewDidLoad()
  
  func stationDidSelect(with: StationRemote)
  
  // MARK: - Output
  
  var viewState: Observable<SimpleViewState<PopularCellViewModel>> { get }
}

final class PopularViewModel: PopularViewModelProtocol {
  
  private let fetchStationsUseCase: FetchStationsLocalUseCase
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<PopularCellViewModel>>(value: .empty)
  
  private weak var delegate: PopularViewModelDelegate?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public Api
  
  let viewState: Observable<SimpleViewState<PopularCellViewModel>>
  
  // MARK: - Initializers
  
  init(fetchStationsUseCase: FetchStationsLocalUseCase, delegate: PopularViewModelDelegate? = nil) {
    self.fetchStationsUseCase = fetchStationsUseCase
    self.delegate = delegate
    
    viewState = viewStateObservableSubject.asObservable()
  }
  
  // MARK: - Public Api
  
  func viewDidLoad() {
    let request = FetchStationsLocalUseCaseRequestValue()
    
    fetchStationsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] entities in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: entities)
      })
      .disposed(by: disposeBag)
  }
  
  func stationDidSelect(with station: StationRemote) {
    delegate?.stationDidSelect(station: station)
  }
  
  // MARK: - Private
  
  fileprivate func processFetched(for items: [StationRemote]) {
    let popularCells = items.map( PopularCellViewModel.init )
    
    if popularCells.isEmpty {
      viewStateObservableSubject.onNext(.empty)
    } else {
      viewStateObservableSubject.onNext(.populated(popularCells))
    }
  }
}
