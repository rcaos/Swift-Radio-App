//
//  RadioClient.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class ShowClient: ApiClient {
    
    let session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    //MARK: - Radio Show Detail
    
    func getShowOnlineDetail(group: Group, completion: @escaping (Result<Show?, APIError >) -> Void ) {
        switch group {
        case .rpp(let rpp) :
            fetchForRPP( rpp.id , completion: completion )
        case .crp(let crp) :
            fetchForCRP( crp.base, completion: completion )
        case .unknown:
            print("Not implemented")
        }
    }
    
    //MARK: - Private
   
    private func fetchForRPP(_ id : String, completion: @escaping (Result<Show?, APIError >) -> Void) {
        let request = GroupRPPProvider.getNowShowDetail(id).urlRequest
        
        let newCompletionHandler: (Result<GrupoRPPResult?, APIError>) -> Void = { result in
            switch result {
            case .success(let data):
                guard let showDetail = data?.results.radioDetail else { return }
                completion( Result.success(showDetail) )
            case .failure(let error):
                completion( Result.failure(error) )
            }
        }
        
        fetch(with: request,
              decode: { json -> GrupoRPPResult? in
                guard let showResult = json as? GrupoRPPResult else { return nil }
                return showResult
        }, completion: newCompletionHandler)
        
    }
    
    private func fetchForCRP(_ base: String, completion: @escaping (Result<Show?, APIError >) -> Void) {
        let request = GroupCRPProvider.getNowShowDetail(base).urlRequest
        
        let newCompletionHandler: (Result<ShowCRP?, APIError>) -> Void = { result in
            switch result {
            case .success(let data):
                guard let showDetail = data else { return }
                completion( Result.success(showDetail) )
                
            case .failure(let error):
                completion( Result.failure(error))
            }
        }
        
        fetch(with: request,
              decode: { json -> ShowCRP? in
                guard let showResult = json as? ShowCRP else { return nil }
                return showResult
        }, completion: newCompletionHandler)
        
    }
}
