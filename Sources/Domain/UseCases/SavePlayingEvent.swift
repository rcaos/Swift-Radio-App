//
//  SavePlayingEvent.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol SavePlayingEventUseCase {
  func execute(requestValue: SavePlayingEventUseCaseRequestValue) -> Observable<Void>
}
public struct SavePlayingEventUseCaseRequestValue {
  public let event: EventPlay

  public init(event: EventPlay) {
    self.event = event
  }
}

public final class DefaultSavePlayingEventUseCase: SavePlayingEventUseCase {
  
  private let analyticsRepository: AnalyticsRepository
  
  public init(analyticsRepository: AnalyticsRepository) {
    self.analyticsRepository = analyticsRepository
  }
  
  public func execute(requestValue: SavePlayingEventUseCaseRequestValue) -> Observable<Void> {
    return analyticsRepository.savePlaying(event: requestValue)
  }
}