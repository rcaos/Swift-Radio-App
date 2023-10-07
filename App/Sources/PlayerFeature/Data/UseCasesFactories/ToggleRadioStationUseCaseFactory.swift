//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation
import LocalDatabaseClient

public struct ToggleRadioStationUseCaseFactory {

  public static func buildLocalUseCase(localDataBaseClient: LocalDatabaseClient) -> ToggleRadioStationFavoriteUseCase {
    let favoriteRepository: RadioFavoritesStationsRepository = .liveLocalRepository(localDataBaseClient: localDataBaseClient)
    return .live(radioStationsRepository: favoriteRepository)
  }
}
