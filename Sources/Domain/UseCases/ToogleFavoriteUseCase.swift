//
//  ToogleFavoriteUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol ToggleFavoriteUseCase {
    func execute(requestValue: ToogleFavoriteUseCaseRequestValue,
                 completion: @escaping (Result<Bool, Error>) -> Void )
}

struct ToogleFavoriteUseCaseRequestValue {
    let station: SimpleStation
}

final class DefaultToogleFavoriteUseCase: ToggleFavoriteUseCase {
    
    private let favoritesRepository: FavoritesRepository
    
    init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }

  // TODO, check this
    func execute(requestValue: ToogleFavoriteUseCaseRequestValue, completion: @escaping (Result<Bool, Error>) -> Void) {
      favoritesRepository.toogleFavorite(station: requestValue.station)
    }
}
