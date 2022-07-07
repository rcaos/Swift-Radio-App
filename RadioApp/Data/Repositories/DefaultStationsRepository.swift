//
//  DefaultStationsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultStationsRepository {
  
  private let dataTransferService: DataTransferService
  
  init(dataTransferService: DataTransferService) {
    self.dataTransferService = dataTransferService
  }
}

// MARK: - StationsRepository

extension DefaultStationsRepository: StationsRepository {
  
  func stationsList() -> Observable<[StationRemote]> {
    let endPoint = StationProvider.getAll
    
    return dataTransferService.request(endPoint, [StationRemote].self)
  }
}
