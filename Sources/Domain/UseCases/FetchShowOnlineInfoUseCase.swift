//
//  FetchShowOnlineInfoUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public final class DefaultFetchShowOnlineInfoUseCase: FetchShowOnlineInfoUseCase {
  
  private let showDetailRepository: ShowDetailsRepository
  
  public init(showDetailRepository: ShowDetailsRepository) {
    self.showDetailRepository = showDetailRepository
  }
  
  public func execute(requestValue: FetchShowOnlineInfoUseCaseRequestValue) -> Observable<Show> {
    return showDetailRepository.fetchShowDetails(group: requestValue.group)
  }
  
}
