//
//  DefaultShowDetailsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

final class DefaultShowDetailsRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - StationsRepository

extension DefaultShowDetailsRepository: ShowDetailsRepository {
    
    func fetchShowDetails(group: Group, completion: @escaping (Result<Show, Error>) -> Void) -> Cancellable? {
        
        switch group {
        case .rpp(let rpp):
            return fetchRPPDetails(rpp.id, completion: completion)
            
        case .crp(let crp):
            return fetchCRPDetails(crp.base, completion: completion)
            
        case .unknown:
            print("Not implemented")
            return nil
        }
    }
    
    // MARK: - PRIVATE
    
    private func fetchRPPDetails(_ id: String, completion: @escaping (Result<Show, Error>) -> Void ) -> Cancellable? {
        
        let endPoint = GroupRPPProvider.getNowShowDetail(id)
        
        let newCompletion: (Result<GroupRPPResult, Error>) -> Void = { result in
            switch result {
            case .success(let response):
                let showDetail = response.results.radioDetail
                completion( Result.success(showDetail) )
            case .failure(let error):
                completion( Result.failure(error) )
            }
        }
        
        let networkTask = dataTransferService.request(service: endPoint,
                                                      decodeType: GroupRPPResult.self,
                                                      completion: newCompletion)
        return RepositoryTask(networkTask: networkTask)
    }
    
    private func fetchCRPDetails(_ base: String, completion: @escaping (Result<Show, Error>) -> Void ) -> Cancellable? {
        
        let endPoint = GroupCRPProvider.getNowShowDetail(base)
        
        let newCompletion: (Result<ShowCRP, Error>) -> Void = { result in
            switch result {
            case .success(let response):
                completion( Result.success(response) )
            case .failure(let error):
                completion( Result.failure(error) )
            }
        }
        
        let networkTask = dataTransferService.request(service: endPoint,
                                                      decodeType: ShowCRP.self,
                                                      completion: newCompletion)
        return RepositoryTask(networkTask: networkTask)
    }
}
