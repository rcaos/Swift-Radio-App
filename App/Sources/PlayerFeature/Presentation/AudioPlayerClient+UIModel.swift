//
//  Created by Jeans Ruiz on 5/09/23.
//

import AudioPlayerClient
import Foundation

extension AudioPlayerClient.AudioPlayerStatus {
  var playerStatusUIModel: MiniPlayerUIModel.PlayerStatus {
    switch self {
    case .buffering:
      return .loading
    case .playing:
      return .playing
    case .stopped, .error:
      return .stopped
    }
  }
}
