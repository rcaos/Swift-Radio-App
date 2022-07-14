//
//  ShowDetailsRepository.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol ShowDetailsRepository {
  func fetchShowDetails(group: Group) -> Observable<Show>
}
