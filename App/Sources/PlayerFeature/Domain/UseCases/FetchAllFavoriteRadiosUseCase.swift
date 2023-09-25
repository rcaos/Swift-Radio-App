//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

public struct FetchAllFavoriteRadiosUseCase {
  public var execute: () async -> [RadioStationFavorite]
}

extension FetchAllFavoriteRadiosUseCase {
  static func live(
    radioStationsRepository: RadioFavoritesStationsRepository
  ) -> FetchAllFavoriteRadiosUseCase {
    return FetchAllFavoriteRadiosUseCase(execute: {
      return await radioStationsRepository.fetchAllFavorites()
    })
  }
}
