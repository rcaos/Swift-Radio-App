//
//  StationsLocalRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol StationsLocalRepository {
  
  func saveStations(stations: [StationRemote], completion: @escaping (Result<Void, Error>) -> Void)
  
  func stationsList(completion: @escaping (Result<[StationRemote], Error>) -> Void)
  
  func findStations(with stations: [SimpleStation], completion: @escaping (Result<[StationRemote], Error>) -> Void)
}
