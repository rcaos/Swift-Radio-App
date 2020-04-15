//
//  FetchStationsLocalUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchStationsLocalUseCase {
  
  func execute(requestValue: FetchStationsLocalUseCaseRequestValue) -> Observable<[StationRemote]>
}

struct FetchStationsLocalUseCaseRequestValue {
  
}

final class DefaultFetchStationsLocalUseCase: FetchStationsLocalUseCase {
  
  private let stationsLocalRepository: StationsLocalRepository
  
  init(stationsLocalRepository: StationsLocalRepository) {
    self.stationsLocalRepository = stationsLocalRepository
  }
  
  func execute(requestValue: FetchStationsLocalUseCaseRequestValue) -> Observable<[StationRemote]> {
    return stationsLocalRepository.stationsList()
  }
  
}
