//
//  DefaultAnalyticsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultAnalyticsRepository {
  
  private let analyticsService: AnalyticsServiceProtocol
  
  init(analyticsService: AnalyticsServiceProtocol) {
    self.analyticsService = analyticsService
  }
  
}

extension DefaultAnalyticsRepository: AnalyticsRepository {
  
  func savePlaying(event: SavePlayingEventUseCaseRequestValue) -> Observable<Void> {
    return analyticsService.logEvent(type: EventsType.stationPlaying,
                                     values: event.event.asDictionary)
  }
  
  func addFavorite(event: EventFavorite) -> Observable<Void> {
    return analyticsService.logEvent(type: EventsType.addFavorite, values: event.asDictionary)
  }
  
  func removeFavorite(event: EventFavorite) -> Observable<Void> {
    return analyticsService.logEvent(type: EventsType.removeFavorite, values: event.asDictionary)
  }
}
