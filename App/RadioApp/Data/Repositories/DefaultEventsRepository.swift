//
//  DefaultEventsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultEventsRepository {
  
  private let dataTransferService: TransferServiceProtocol
  
  init(dataTransferService: TransferServiceProtocol) {
    self.dataTransferService = dataTransferService
  }
}

extension DefaultEventsRepository: EventsRepository {
  
  func saveStationError(station: SaveStationErrorUseCaseRequestValue) -> Observable<String> {
    let path = "/events-error/"
    return dataTransferService.save(path: path, station.event, nil)
  }
}
