//
//  AnalyticsServiceProtocol.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Domain

public protocol AnalyticsServiceProtocol {
  
  func logEvent(type: EventsType, values: [String: Any]?) -> Observable<Void>
}
