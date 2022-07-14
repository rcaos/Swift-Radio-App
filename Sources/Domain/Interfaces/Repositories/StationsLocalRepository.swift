//
//  StationsLocalRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol StationsLocalRepository {
  
  func saveStations(stations: [StationRemote]) -> Observable<Void>
  
  func stationsList() -> Observable<[StationRemote]>
  
  func findStations(with stations: [SimpleStation]) -> Observable<[StationRemote]>
}
