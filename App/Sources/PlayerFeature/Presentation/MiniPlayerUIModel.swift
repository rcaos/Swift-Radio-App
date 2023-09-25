//
//  Created by Jeans Ruiz on 5/09/23.
//

import Foundation

public struct MiniPlayerUIModel {
  public let stationId: String
  public var isFavorite: Bool
  public var state: PlayerStatus
  public var title: String
  public var subtitle: String
  public var imageURL: URL?

  public init(
    stationId: String,
    isFavorite: Bool,
    state: PlayerStatus,
    title: String,
    subtitle: String,
    imageURL: URL?
  ) {
    self.stationId = stationId
    self.isFavorite = isFavorite
    self.state = state
    self.title = title
    self.subtitle = subtitle
    self.imageURL = imageURL
  }

  public enum PlayerStatus {
    case loading
    case stopped
    case playing

    var isPlaying: Bool {
      return .playing == self
    }

    var isLoading: Bool {
      return .loading == self
    }
  }
}
