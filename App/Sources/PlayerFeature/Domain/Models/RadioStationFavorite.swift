//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

public struct RadioStationFavorite {
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
