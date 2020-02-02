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
                
                strongSelf.stationsLocalRepository.saveStations(stations: stationsResult.stations) { coreDataResult in
                    
                    DispatchQueue.main.async {
                        switch coreDataResult {
                        case .success :
                            completion( result )
                        case .failure(let error):
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
