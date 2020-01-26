//
//  FetchFavoritesStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

protocol FetchFavoritesStationsUseCase {
    
    func execute(requestValue: FetchFavoritesStationsUseCaseRequestValue,
                 completion: @escaping (Result<[StationRemote], Error>) -> Void ) -> Cancellable?
}

struct FetchFavoritesStationsUseCaseRequestValue {
    
}

final class DefaultFetchFavoritesStationsUseCase: FetchFavoritesStationsUseCase {
    
    private let favoritesRepository: FavoritesRepository
    private let localsRepository: StationsLocalRepository
    
    init(favoritesRepository: FavoritesRepository, localsRepository: StationsLocalRepository) {
        self.favoritesRepository = favoritesRepository
        self.localsRepository = localsRepository
    }
    
    func execute(requestValue: FetchFavoritesStationsUseCaseRequestValue, completion: @escaping (Result<[StationRemote], Error>) -> Void) -> Cancellable? {
        
        favoritesRepository.favoritesList() { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let stations):
                strongSelf.localsRepository.findStations(with: stations, completion: completion)
            case .failure :
                completion( .success([]) )
            }
        }
        return nil
    }
    
}
