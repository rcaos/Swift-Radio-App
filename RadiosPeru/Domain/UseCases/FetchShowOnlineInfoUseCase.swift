//
//  FetchShowOnlineInfoUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchShowOnlineInfoUseCase {
    
    func execute(requestValue: FetchShowOnlineInfoUseCaseRequestValue,
                 completion: @escaping (Result<Show, Error>) -> Void ) -> Cancellable?
}

struct FetchShowOnlineInfoUseCaseRequestValue {
    let group: Group
}

final class DefaultFetchShowOnlineInfoUseCase: FetchShowOnlineInfoUseCase {
    
    private let showDetailRepository: ShowDetailsRepository
    
    init(showDetailRepository: ShowDetailsRepository) {
        self.showDetailRepository = showDetailRepository
    }
    
    func execute(requestValue: FetchShowOnlineInfoUseCaseRequestValue, completion: @escaping (Result<Show, Error>) -> Void) -> Cancellable? {
        
        return showDetailRepository.fetchShowDetails(group: requestValue.group, completion: completion)
    }
    
}
