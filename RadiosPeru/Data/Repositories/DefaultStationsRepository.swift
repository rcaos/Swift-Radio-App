//
//  DefaultStationsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultStationsRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultStationsRepository: StationsRepository {
    
    func stationsList(completion: @escaping (Result<StationResult, Error>) -> Void) -> Cancellable? {
        let endPoint = StationProvider.getAll
        
        let networkTask = dataTransferService.request(service: endPoint,
                                                      decodeType: StationResult.self, completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
}
