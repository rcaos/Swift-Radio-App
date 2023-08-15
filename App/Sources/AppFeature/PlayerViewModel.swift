//
//  Created by Jeans Ruiz on 14/08/23.
//

import Foundation
import AudioPlayerClient
import AsyncAlgorithms

public enum PlayerStatusUIModel {
  case loading
  case stopped
  case playing
}

//public class PlayerViewModel: ObservableObject {
  //@Published public var status: PlayerStatusUIModel = .stopped

//@ MainActor???
// Discover concurrency in SwiftUI
// https://www.wwdcnotes.com/notes/wwdc21/10019/
// https://developer.apple.com/videos/play/wwdc2021/10019/

// Swift concurrency: Update a sample app
// https://www.wwdcnotes.com/notes/wwdc21/10194/
// https://developer.apple.com/videos/play/wwdc2021/10194/
@Observable public class PlayerViewModel {
  public var status: PlayerStatusUIModel = .stopped

  public init() {
    print("init viewModel: \(Self.self)")
  }

  // call once????
  public func onAppear() {
    print("onAppear")
    Task {
      for await value in AudioPlayerClient.live.delegate().removeDuplicates() {
        print("✅viewModel.event: \(value)")
        switch value {
        case .changeStatus(let status):
          self.status = mapPlayerStatus(status)
        }
      }
    }
  }

  private func mapPlayerStatus(_ playerState: AudioPlayerClient.AudioPlayerStatus) -> PlayerStatusUIModel {
    switch playerState {
    case .buffering:
      return .loading
    case .playing:
      return .playing
    case .stopped, .error:
      return .stopped
    }
  }

  //http://tunein-icecast.mediaworks.nz/rock_128kbps
  //http://rfcmedia.streamguys1.com/classicrock.mp3
  //http://104.250.149.122:8082/stream
  public func playRadioOne() {
    AudioPlayerClient.live.load("http://cassini.shoutca.st:9300/stream")
  }

  public func playRadioTwo() {
    AudioPlayerClient.live.load("http://strm112.1.fm/acountry_mobile_mp3")
  }

  public func playRadioThree() {
    AudioPlayerClient.live.load("https://mock.com")
  }

  public func toggle() {
    AudioPlayerClient.live.toggle()
  }
}
