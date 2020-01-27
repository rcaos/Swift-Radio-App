//
//  StationsLocalStorage.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol StationsLocalStorage {
    
    // Es idéntico a "MoviesQueriesRepository" ???
    
    // DefaultMoviesQueriesRepository lo utiliza como variable
    // Tmb implementa el protocol "MoviesQueriesRepository"
    // Que solo llama a los methods iguales, como un puente
    
    // Este protocol lo implementan:
    // CoreDataStorage
    // UserDefaultsStorage
    // RealmStorage, etc
    
    func saveStations(stations: [StationRemote], completion: @escaping (Result<Void, Error>) -> Void)
    
    func stationsList(completion: @escaping (Result<[StationRemote], Error>) -> Void)
    
    func findStations(with stations: [SimpleStation] ,completion: @escaping (Result<[StationRemote], Error>) -> Void)
}
