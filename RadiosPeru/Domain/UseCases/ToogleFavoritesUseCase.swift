//
//  ToggleFavoritesUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol ToggleFavoritesUseCase {
    
    @discardableResult
    func execute(requestValue: ToggleFavoriteUseCaseRequestValue,
                 completion: @escaping (Result<Bool, Error>) -> Void ) -> Cancellable?
}

struct ToggleFavoriteUseCaseRequestValue {
    let station: SimpleStation
}

final class DefaultToggleFavoriteUseCase: ToggleFavoritesUseCase {
    
    private let favoritesRepository: FavoritesRepository
    
    init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }
    
    func execute(requestValue: ToggleFavoriteUseCaseRequestValue, completion: @escaping (Result<Bool, Error>) -> Void) -> Cancellable? {
        
        favoritesRepository.toogleFavorite(station: requestValue.station,
                                           completion: completion)
        return nil
    }
}
