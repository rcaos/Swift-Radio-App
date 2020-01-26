//
//  ToogleFavoriteUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol ToogleFavoriteUseCase {
    
    func execute(requestValue: ToogleFavoriteUseCaseRequestValue,
                 completion: @escaping (Result<Bool, Error>) -> Void ) -> Cancellable?
}

struct ToogleFavoriteUseCaseRequestValue {
    let station: SimpleStation
}

final class DefaultSaveAsFavoriteUseCase: ToogleFavoriteUseCase {
    
    private let favoritesRepository: FavoritesRepository
    
    init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }
    
    func execute(requestValue: ToogleFavoriteUseCaseRequestValue, completion: @escaping (Result<Bool, Error>) -> Void) -> Cancellable? {
        
        favoritesRepository.toogleFavorite(station: requestValue.station,
                                           completion: completion)
        return nil
    }
}
