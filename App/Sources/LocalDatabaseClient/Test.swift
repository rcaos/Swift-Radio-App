//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

#if DEBUG
extension LocalDatabaseClient {
  public static var noop: LocalDatabaseClient = {
    return LocalDatabaseClient(
      toggleFavoriteStation: { _ in true },
      fetchAllFavorites: { [] },
      getStationById: { _ in nil }
    )
  }()

  public static func mock(
    toggleFavoriteStation: @escaping (FavoriteStation) async -> Bool = { _ in true },
    fetchAllFavorites: @escaping () async -> [FavoriteStation] = { [] },
    getStationById: @escaping (String) async -> FavoriteStation? = { _ in nil }
  ) -> LocalDatabaseClient {
    return LocalDatabaseClient(
      toggleFavoriteStation: toggleFavoriteStation,
      fetchAllFavorites: fetchAllFavorites,
      getStationById: getStationById
    )
  }
}
#endif
