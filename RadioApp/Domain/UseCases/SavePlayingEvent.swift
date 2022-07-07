//
//  SavePlayingEvent.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol SavePlayingEventUseCase {
  func execute(requestValue: SavePlayingEventUseCaseRequestValue) -> Observable<Void>
}

struct SavePlayingEventUseCaseRequestValue {
  let event: EventPlay
}

final class DefaultSavePlayingEventUseCase: SavePlayingEventUseCase {
  
  private let analyticsRepository: AnalyticsRepository
  
  init(analyticsRepository: AnalyticsRepository) {
    self.analyticsRepository = analyticsRepository
  }
  
  func execute(requestValue: SavePlayingEventUseCaseRequestValue) -> Observable<Void> {
    return analyticsRepository.savePlaying(event: requestValue)
  }
}
