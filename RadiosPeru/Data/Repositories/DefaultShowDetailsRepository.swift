//
//  DefaultShowDetailsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultShowDetailsRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - StationsRepository

extension DefaultShowDetailsRepository: ShowDetailsRepository {
  
  func fetchShowDetails(group: Group) -> Observable<Show> {
    
    switch group {
    case .rpp(let rpp) :
      return fetchRPPDetails(rpp.id)
      
    case .crp(let crp) :
      return fetchCRPDetails(crp.base)
      
    case .unknown:
      return Observable.empty()
    }
  }
  
  // MARK: - Private
  
  private func fetchRPPDetails(_ id: String) -> Observable<Show> {
    
    let endPoint = GroupRPPProvider.getNowShowDetail(id)
    
    return dataTransferService.request(endPoint, GroupRPPResult.self)
      .flatMap { result -> Observable<Show> in
        return Observable.just( result.results.radioDetail )
    }
  }
  
  private func fetchCRPDetails(_ base: String) -> Observable<Show> {
    
    let endPoint = GroupCRPProvider.getNowShowDetail(base)
    
    return dataTransferService.request(endPoint, ShowCRP.self)
      .flatMap { result -> Observable<Show> in
        return Observable.just(result)
    }
  }
}
