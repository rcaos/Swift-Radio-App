//
//  FetchStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchStationsUseCase {
  
  func execute(requestValue: FetchStationsUseCaseRequestValue) -> Observable<[StationRemote]>
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
  
  func execute(requestValue: FetchStationsUseCaseRequestValue)-> Observable<[StationRemote]> {
    return stationsRepository.stationsList()
      .flatMap { stations -> Observable<[StationRemote]> in
        self.stationsLocalRepository.saveStations(stations: stations)
          .flatMap { _ -> Observable<[StationRemote]> in
            return Observable.just(stations)
        }
    }
  }
  
}
