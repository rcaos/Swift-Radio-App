//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation
import LocalDatabaseClient

public struct FetchAllFavoriteRadiosUseCaseFactory {

  public static func buildLocalUseCase(localDataBaseClient: LocalDatabaseClient) -> FetchAllFavoriteRadiosUseCase {
    let favoriteRepository: RadioFavoritesStationsRepository = .liveLocalRepository(localDataBaseClient: localDataBaseClient)
    return .live(radioStationsRepository: favoriteRepository)
  }
}
