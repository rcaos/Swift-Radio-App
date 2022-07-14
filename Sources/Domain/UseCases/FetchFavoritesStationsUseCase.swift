//
//  FetchFavoritesStationsUseCase.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FetchFavoritesStationsUseCase {
  func execute(requestValue: FetchFavoritesStationsRequestValue) -> Observable<[StationRemote]>
}

public struct FetchFavoritesStationsRequestValue {
  public init() { }
}

public final class DefaultFetchFavoritesStationsUseCase: FetchFavoritesStationsUseCase {
  
  private let favoritesRepository: FavoritesRepository
  private let localsRepository: StationsLocalRepository
  
  public init(favoritesRepository: FavoritesRepository, localsRepository: StationsLocalRepository) {
    self.favoritesRepository = favoritesRepository
    self.localsRepository = localsRepository
  }
  
  public func execute(requestValue: FetchFavoritesStationsRequestValue) -> Observable<[StationRemote]> {
    return favoritesRepository.favoritesList()
      .flatMap { [weak self] stations -> Observable<[StationRemote]> in
        guard let strongself = self else { return Observable.just([]) }
        return strongself.localsRepository.findStations(with: stations)
    }
    .flatMap { stations -> Observable<[StationRemote]> in
      return Observable.just( stations.filter { $0.isActive })
    }
  }
  
}
