//
//  FetchStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchStationsUseCase {
    
    func execute(requestValue: FetchStationsUseCaseRequestValue,
                 completion: @escaping (Result<StationResult, Error>) -> Void ) -> Cancellable?
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
    
    func execute(requestValue: FetchStationsUseCaseRequestValue, completion: @escaping (Result<StationResult, Error>) -> Void) -> Cancellable? {
        
        return stationsRepository.stationsList() { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let stationsResult):
                print("aqui ya retornaron: [\(stationsResult.stations.count)]")
                
                strongSelf.stationsLocalRepository.saveStations(stations: stationsResult.stations) { coreDataResult in
                    
                    // Necesario volver al Main Thread
                    // porque CoreData save in .background
                    DispatchQueue.main.async {
                        switch coreDataResult {
                        case .success :
                            print("-- Ok al guardar en CoreData")
                            completion( result )
                        case .failure(let error):
                            print("-- error al guardar en CoreData:\(error)")
                            completion( .failure(error) )
                        }
                    }
                }
            case .failure:
                completion(result)
            }
        }
    }
    
}
