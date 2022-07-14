//
//  AnalyticsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol AnalyticsRepository {
  
  func savePlaying(event: SavePlayingEventUseCaseRequestValue) -> Observable<Void>
  
  func addFavorite(event: EventFavorite) -> Observable<Void>
  
  func removeFavorite(event: EventFavorite) -> Observable<Void>
}
