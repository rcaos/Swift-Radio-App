//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation
import LocalDatabaseClient

extension RadioFavoritesStationsRepository {

  static func liveLocalRepository(localDataBaseClient: LocalDatabaseClient) -> RadioFavoritesStationsRepository {
    return .init(
      toggleFavoriteStation: { model in
        return await localDataBaseClient.toggleFavoriteStation(.init(model))
      },
      fetchAllFavorites: {
        return await localDataBaseClient.fetchAllFavorites().map { .init($0) }
      }
    )
  }
}

extension RadioStationFavorite {
  public init(_ model: LocalDatabaseClient.FavoriteStation) {
    self.init(
      id: model.id,
      name: model.name,
      description: model.description,
      pathImageURL: model.pathImageURL
    )
  }
}

extension LocalDatabaseClient.FavoriteStation {
  public init(_ model: RadioStationFavorite) {
    self.init(
      id: model.id,
      name: model.name,
      description: model.description,
      pathImageURL: model.pathImageURL
    )
  }
}
