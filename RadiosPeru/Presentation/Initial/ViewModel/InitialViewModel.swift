//
//  InitialViewModel.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift

final class InitialViewModel {
  
  private let fetchStationsUseCase: FetchStationsUseCase
  
  var stationsFetched: (() -> Void)?
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(fetchStationsUseCase: FetchStationsUseCase) {
    self.fetchStationsUseCase = fetchStationsUseCase
  }
  
  // MARK: - Public
  
  public func getStations() {
    let request = FetchStationsUseCaseRequestValue()
    
    fetchStationsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.stationsFetched?()
        }, onError: { error in
          print("error to Fetch Stations: [\(error)]")
      })
      .disposed(by: disposeBag)
  }
}
