//
//  AnalyticsClient.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 5/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import Firebase

class AnalyticsClient {
  
}

extension AnalyticsClient: AnalyticsServiceProtocol {
  
  func logEvent(type: EventsType, values: [String: Any]?) -> Observable<Void> {
    Analytics.logEvent(type.rawValue, parameters: values)
    return Observable.just(())
  }
}
