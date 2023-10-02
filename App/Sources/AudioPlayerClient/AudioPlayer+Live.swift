//
//  Created by Jeans Ruiz on 14/08/23.
//

import Combine
import Foundation
import AVFoundation

extension AudioPlayerClient {
  public static let live: AudioPlayerClient = {
    let audioPlayer = AudioPlayerAVP()

    return AudioPlayerClient(
      load: { audioPlayer.load($0) },
      play: { audioPlayer.play() },
      stop: { audioPlayer.stop() },
      toggle: { audioPlayer.toggle() },
      delegate: { return audioPlayer.delegate() }
    )
  }()
}

private class AudioPlayerAVP: NSObject {

  private let player: AVPlayer

  private var timeControlStatusObserver: NSKeyValueObservation?
  private var playerStatusObserver: NSKeyValueObservation?
  private var currentItemObserver: NSKeyValueObservation?
  private var currentItemStatusObserver: NSKeyValueObservation?

  private var continuation: AsyncStream<AudioPlayerClient.DelegateEvent>.Continuation?
  private var disposeBag = Set<AnyCancellable>()

  override init() {
    print("Init: \(Self.self)")

    let audioSession = AVAudioSession.sharedInstance()
    try? audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker]) // .playBack???
    try? audioSession.setMode(.default)
    try? audioSession.setActive(true)

    player = AVPlayer()
    super.init()

    //setupObservers()

#warning("todo, add notification, AVAudioSession.interruptionNotification")
#warning("todo, setup MPRemoteCommandCenter")
    subscribeToAudioInterruption()
  }

  deinit {
    print("Deinit: \(Self.self)")
  }

  private func setupObservers() {
    playerStatusObserver = player.observe(\.status, options: [.initial, .new]) { [weak self] player, change in
      if let error = player.error ?? player.currentItem?.error {
        print("1. playerStatusObserver fire it, error player? \(player.error), error item?: \(player.currentItem?.error)")
        self?.continuation?.yield(.changeStatus(.error))
      }
    }

    timeControlStatusObserver = player.observe(\.timeControlStatus) { [weak self] player, change in
      self?.playerDidChangeTimeControlStatus(in: player)
    }

    currentItemObserver = player.observe(\.currentItem, options: [.initial, .new]) { [weak self] player, change in
      self?.currentItemStatusObserver = player.currentItem?.observe(\.status) { item, _ in
        print("3. currentItemStatusObserver \(item.status.descriptionValue)")

        switch item.status {
        case .failed, .unknown:
          self?.continuation?.yield(.changeStatus(.stopped))
        case.readyToPlay:
          player.play()
        @unknown default:
          break
        }
      }
    }
  }

  private func playerDidChangeTimeControlStatus(in player: AVPlayer) {
    print("🔥2. Status: \(player.timeControlStatus.descriptionValue)")
    switch player.timeControlStatus {
    case .waitingToPlayAtSpecifiedRate:
      continuation?.yield(.changeStatus(.buffering))
    case .paused:
      continuation?.yield(.changeStatus(.stopped))
    case .playing:
      continuation?.yield(.changeStatus(.playing))
    @unknown default:
      break
    }
  }

  func load(_ url: String) {
    print("I will load: \(url)")
    let sourceURL = URL(string: url)! // fix
    // check if is the same URL?, return
    if let asset = player.currentItem?.asset as? AVURLAsset, sourceURL == asset.url {
      return
    }

    stop()
    player.replaceCurrentItem(with: AVPlayerItem(url: sourceURL))
    setupObservers()

    print("🚨Buffering")
    continuation?.yield(.changeStatus(.buffering))
  }

  func play() {
    // Handle other status here ????
    player.play()
  }

  func stop() {
    player.pause()
    player.replaceCurrentItem(with: nil)
  }

  func toggle() {
//    print("toggle: \(player.timeControlStatus.descriptionValue)")
//    print("toggle item: \(player.currentItem?.status.descriptionValue)")
//    print("toggle item: \( (player.currentItem?.asset as? AVURLAsset)?.url )")
    switch player.timeControlStatus {
    case .paused:
      if let currentItem = player.currentItem, currentItem.status != .failed {
        player.play()
      }
    case .playing:
      player.pause()
    case .waitingToPlayAtSpecifiedRate:
      player.pause()
    @unknown default:
      break
    }
  }

  func delegate() -> AsyncStream<AudioPlayerClient.DelegateEvent> {
    return AsyncStream { [weak self] continuation in
      self?.continuation = continuation

      continuation.onTermination = { status in
        print("\(Self.self) Stream finished with status: \(status)")
      }
    }
  }

  private func subscribeToAudioInterruption() {
    NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
      .sink(receiveValue: { [weak self] notification in
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
          return
        }
        
        switch type {
        case .began:
          self?.player.pause()
          
        case .ended:
          guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
          let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
          if options.contains(.shouldResume) {
            self?.player.play() // An interruption ended. Resume playback.
          }
        default:
          break
        }
      })
      .store(in: &disposeBag)
  }
}

private extension AVPlayerItem.Status {
  var descriptionValue: String {
    switch self {
    case .unknown:
      return "unknown"
    case .readyToPlay:
      return "readyToPlay"
    case .failed:
      return "failed"
    @unknown default:
      return "@unknown"
    }
  }
}


private extension AVPlayer.TimeControlStatus {
  var descriptionValue: String {
    switch self {
    case .paused:
      return "paused"
    case .waitingToPlayAtSpecifiedRate:
      return "waitingToPlayAtSpecifiedRate"
    case .playing:
      return "playing"
    @unknown default:
      return "@unknown"
    }
  }
}
