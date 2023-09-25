//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation
import SwiftData

@Model
public final class RadioStationFavoriteSD {
  public let id: String
  public let name: String
  public let descriptionStation: String
  public let pathImageURL: URL
  
  public init(
    id: String,
    name: String,
    descriptionStation: String,
    pathImageURL: URL
  ) {
    self.id = id
    self.name = name
    self.descriptionStation = descriptionStation
    self.pathImageURL = pathImageURL
  }

  convenience init(_ model: LocalDatabaseClient.FavoriteStation) {
    self.init(
      id: model.id,
      name: model.name,
      descriptionStation: model.description,
      pathImageURL: model.pathImageURL
    )
  }

  func asModel() -> LocalDatabaseClient.FavoriteStation {
    return .init(
      id: id,
      name: name,
      description: descriptionStation,
      pathImageURL: pathImageURL
    )
  }
}
