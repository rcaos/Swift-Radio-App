//
//  AskFavoriteUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol AskFavoriteUseCase {
    
    @discardableResult
    func execute(requestValue: AskFavoriteUseCaseRequestValue,
                 completion: @escaping (Result<Bool, Error>) -> Void ) -> Cancellable?
}

struct AskFavoriteUseCaseRequestValue {
    let station: SimpleStation
}

final class DefaultAskFavoriteUseCase: AskFavoriteUseCase {
    
    private let favoritesRepository: FavoritesRepository
    
    init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }
    
    func execute(requestValue: AskFavoriteUseCaseRequestValue, completion: @escaping (Result<Bool, Error>) -> Void) -> Cancellable? {
        
        favoritesRepository.isFavorite(station: requestValue.station, completion: completion)
        return nil
    }
    
}
