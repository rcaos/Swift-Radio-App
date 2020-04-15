//
//  FetchFavoritesStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

protocol FetchFavoritesStationsUseCase {
  
  func execute(requestValue: FetchFavoritesStationsRequestValue) -> Observable<[StationRemote]>
}

struct FetchFavoritesStationsRequestValue {
  
}

final class DefaultFetchFavoritesStationsUseCase: FetchFavoritesStationsUseCase {
  
  private let favoritesRepository: FavoritesRepository
  private let localsRepository: StationsLocalRepository
  
  init(favoritesRepository: FavoritesRepository, localsRepository: StationsLocalRepository) {
    self.favoritesRepository = favoritesRepository
    self.localsRepository = localsRepository
  }
  
  func execute(requestValue: FetchFavoritesStationsRequestValue) -> Observable<[StationRemote]> {
    return favoritesRepository.favoritesList()
      .flatMap { [weak self] stations -> Observable<[StationRemote]> in
        guard let strongself = self else { return Observable.just([]) }
        return strongself.localsRepository.findStations(with: stations)
    }
  }
  
}
