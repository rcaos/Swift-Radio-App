//
//  FetchStationsLocalUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchStationsLocalUseCase {
    
    func execute(requestValue: FetchStationsLocalUseCaseRequestValue,
                 completion: @escaping (Result<[StationRemote], Error>) -> Void ) -> Cancellable?
}

struct FetchStationsLocalUseCaseRequestValue {
    
}

final class DefaultFetchStationsLocalUseCase: FetchStationsLocalUseCase {
    
    private let stationsLocalRepository: StationsLocalRepository
    
    init(stationsRepository: StationsRepository, stationsLocalRepository: StationsLocalRepository) {
        self.stationsLocalRepository = stationsLocalRepository
    }
    
    func execute(requestValue: FetchStationsLocalUseCaseRequestValue, completion: @escaping (Result<[StationRemote], Error>) -> Void) -> Cancellable? {
        
        stationsLocalRepository.stationsList(completion: completion)
        return nil
    }
    
}
