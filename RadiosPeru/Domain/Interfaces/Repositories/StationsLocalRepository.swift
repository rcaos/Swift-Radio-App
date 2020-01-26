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
    
    // 1ero lo usar "DefaultFetchFavoritesStationsUseCase"
    // Usar en "DefaultFetchStationsLocalUseCase"
    func findStations(with stations: [SimpleStation] ,completion: @escaping (Result<[StationRemote], Error>) -> Void)
}
