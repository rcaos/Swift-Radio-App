//
//  SaveStationError.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/28/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol SaveStationStreamError {
  func execute(requestValue: SaveStationErrorUseCaseRequestValue) -> Observable<String>
}

public struct SaveStationErrorUseCaseRequestValue {
  let event: Event

  public init(event: Event) {
    self.event = event
  }
}

final class DefaultSaveStationError: SaveStationStreamError {
  private let eventsRepository: EventsRepository
  
  init(eventsRepository: EventsRepository) {
    self.eventsRepository = eventsRepository
  }
  
  func execute(requestValue: SaveStationErrorUseCaseRequestValue) -> Observable<String> {
    return eventsRepository.saveStationError(station: requestValue)
  }
}
