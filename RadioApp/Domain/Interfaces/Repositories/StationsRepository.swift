//
//  StationsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol StationsRepository {
  
  func stationsList() -> Observable<[StationRemote]>
}
