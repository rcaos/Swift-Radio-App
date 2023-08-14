//
//  Created by Jeans Ruiz on 14/08/23.
//

import Foundation

public struct AudioPlayerClient {
  public var load: (String) -> Void
  public var play: () -> Void
  public var stop: () -> Void
  public var toggle: () -> Void
  public var delegate: () -> AsyncStream<DelegateEvent>

  public enum DelegateEvent: Equatable {
    case changeStatus(AudioPlayerStatus)
  }

  public enum AudioPlayerStatus {
    case buffering
    case playing
    case stopped
    case error
  }
}
