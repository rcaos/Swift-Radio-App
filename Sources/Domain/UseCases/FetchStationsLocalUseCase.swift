//
//  FetchStationsLocalUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FetchStationsLocalUseCase {
  func execute(requestValue: FetchStationsLocalUseCaseRequestValue) -> Observable<[StationRemote]>
}

public struct FetchStationsLocalUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchStationsLocalUseCase: FetchStationsLocalUseCase {
  
  private let stationsLocalRepository: StationsLocalRepository
  
  public init(stationsLocalRepository: StationsLocalRepository) {
    self.stationsLocalRepository = stationsLocalRepository
  }
  
  public func execute(requestValue: FetchStationsLocalUseCaseRequestValue) -> Observable<[StationRemote]> {
    return stationsLocalRepository.stationsList()
      .flatMap { stations -> Observable<[StationRemote]> in
        let filtered = stations
          .filter { $0.isActive }
          .sorted { $0.order < $1.order }
        return Observable.just(filtered)
    }
  }
  
}
