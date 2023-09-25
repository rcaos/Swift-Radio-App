//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

public struct ToggleRadioStationFavoriteUseCase {
  public var execute: (RadioStationFavorite) async -> Bool
}

extension ToggleRadioStationFavoriteUseCase {
  static func live(
    radioStationsRepository: RadioFavoritesStationsRepository
  ) -> ToggleRadioStationFavoriteUseCase {
    return ToggleRadioStationFavoriteUseCase(execute: {
      return await radioStationsRepository.toggleFavoriteStation($0)
    })
  }
}
