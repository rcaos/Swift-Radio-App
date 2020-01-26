//
//  DefaultStationsLocalRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultStationsLocalRepository {
    
    private var stationsPersistentStorage: StationsLocalStorage
    
    init(stationsPersistentStorage: StationsLocalStorage) {
        self.stationsPersistentStorage = stationsPersistentStorage
    }
}

extension DefaultStationsLocalRepository: StationsLocalRepository {
    
    func saveStations(stations: [StationRemote], completion: @escaping (Result<Void, Error>) -> Void) {
        stationsPersistentStorage.saveStations(stations: stations, completion: completion)
    }
    
    func stationsList(completion: @escaping (Result<[StationRemote], Error>) -> Void) {
        stationsPersistentStorage.stationsList(completion: completion)
    }
    
    func findStations(with stations: [SimpleStation], completion: @escaping (Result<[StationRemote], Error>) -> Void) {
        // MARK: - TODO
    }
}
