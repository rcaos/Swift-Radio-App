//
//  StationsLocalRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol StationsLocalRepository {
    
    func saveStations(stations: StationResult, completion: @escaping (Result<StationResult, Error>) -> Void)
    
    func stationsList(completion: @escaping (Result<StationResult, Error>) -> Void)
}
