//
//  Created by Jeans Ruiz on 24/09/23.
//

import Foundation

public struct LocalDatabaseClient {
  public var toggleFavoriteStation: (LocalDatabaseClient.FavoriteStation) async -> Bool
  public var fetchAllFavorites: () async -> [LocalDatabaseClient.FavoriteStation]
  public var getStationById: (String) async -> LocalDatabaseClient.FavoriteStation?

  // MARK: - Models
  public struct FavoriteStation {
    public let id: String
    public let name: String
    public let description: String
    public let pathImageURL: URL

    public init(id: String, name: String, description: String, pathImageURL: URL) {
      self.id = id
      self.name = name
      self.description = description
      self.pathImageURL = pathImageURL
    }
  }
}
