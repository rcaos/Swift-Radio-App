//
//  FetchStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchStationsUseCase {
  
  func execute(requestValue: FetchStationsUseCaseRequestValue) -> Observable<StationResult>
}

struct FetchStationsUseCaseRequestValue {
  
}

final class DefaultFetchStationsUseCase: FetchStationsUseCase {
  
  private let stationsRepository: StationsRepository
  private let stationsLocalRepository: StationsLocalRepository
  
  init(stationsRepository: StationsRepository, stationsLocalRepository: StationsLocalRepository) {
    self.stationsRepository = stationsRepository
    self.stationsLocalRepository = stationsLocalRepository
  }
  
  func execute(requestValue: FetchStationsUseCaseRequestValue)-> Observable<StationResult> {
    return stationsRepository.stationsList()
      .flatMap { results -> Observable<StationResult> in
        self.stationsLocalRepository.saveStations(stations: results.stations)
          .flatMap { _ -> Observable<StationResult> in
            return Observable.just(results)
        }
    }
  }
  
}
