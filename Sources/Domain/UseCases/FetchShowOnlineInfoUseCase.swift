//
//  FetchShowOnlineInfoUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class DefaultFetchShowOnlineInfoUseCase: FetchShowOnlineInfoUseCase {
  
  private let showDetailRepository: ShowDetailsRepository
  
  init(showDetailRepository: ShowDetailsRepository) {
    self.showDetailRepository = showDetailRepository
  }
  
  func execute(requestValue: FetchShowOnlineInfoUseCaseRequestValue) -> Observable<Show> {
    return showDetailRepository.fetchShowDetails(group: requestValue.group)
  }
  
}
