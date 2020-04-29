//
//  EventsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol EventsRepository {
  
  func saveStationError(station: SaveStationErrorUseCaseRequestValue) -> Observable<String>
}
