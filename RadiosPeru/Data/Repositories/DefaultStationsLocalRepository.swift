//
//  DefaultStationsLocalRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultStationsLocalRepository {
  
  private var stationsPersistentStorage: StationsLocalStorage
  
  init(stationsPersistentStorage: StationsLocalStorage) {
    self.stationsPersistentStorage = stationsPersistentStorage
  }
}

extension DefaultStationsLocalRepository: StationsLocalRepository {
  
  func saveStations(stations: [StationRemote])-> Observable<Void> {
    return stationsPersistentStorage.saveStations(stations: stations)
  }
  
  func stationsList() -> Observable<[StationRemote]> {
    return stationsPersistentStorage.stationsList()
  }
  
  func findStations(with stations: [SimpleStation]) -> Observable<[StationRemote]> {
    return stationsPersistentStorage.findStations(with: stations)
  }
}
