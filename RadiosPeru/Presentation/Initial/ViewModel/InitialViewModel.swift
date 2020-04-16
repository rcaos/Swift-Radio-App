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
    //    stationsFetched?()
    
    let request = FetchStationsUseCaseRequestValue()
    
    fetchStationsUseCase.execute(requestValue: request)
      .subscribe(onError: { error in
        print("error to Fetch Stations: [\(error)]")
      }, onCompleted: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.stationsFetched?()
      })
      .disposed(by: disposeBag)
  }
}
