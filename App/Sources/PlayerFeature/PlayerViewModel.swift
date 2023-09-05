//
//  Created by Jeans Ruiz on 14/08/23.
//

import Foundation
import AudioPlayerClient
import AsyncAlgorithms

//public class PlayerViewModel: ObservableObject {
  //@Published public var status: PlayerStatusUIModel = .stopped

//@ MainActor???
// Discover concurrency in SwiftUI
// https://www.wwdcnotes.com/notes/wwdc21/10019/
// https://developer.apple.com/videos/play/wwdc2021/10019/

// Swift concurrency: Update a sample app
// https://www.wwdcnotes.com/notes/wwdc21/10194/
// https://developer.apple.com/videos/play/wwdc2021/10194/

#warning("Rename, this is not a ViewModel anymore")
@Observable public class PlayerViewModel {
  public var stations: [RadioStation] = []
  public var selectedStation: MiniPlayerUIModel?

  private let stationsRepository: RadioStationsRepository = .localRepository

  public init() {
    print("init viewModel: \(Self.self)")
  }

  // call once????
  public func onAppear() {
    print("onAppear ViewModel")

    Task {
      // 1. Load all stations
      stations = await stationsRepository.getAllStations()

      // 2. Subscribe to player
      for await value in AudioPlayerClient.live.delegate().removeDuplicates() {
        print("✅viewModel.event: \(value)")
        switch value {
        case .changeStatus(let status):
          selectedStation?.state = status.playerStatusUIModel
        }
      }
    }
  }

  public func loadStation(stationId: String) {
    if let station = stationsRepository.getStationById(stationId) {
      print("I will load: \(station.audioStreamURL)")
      if selectedStation == nil {
        selectedStation = .init(title: station.name)
      } else {
        selectedStation?.title = station.name
      }

      AudioPlayerClient.live.load(station.audioStreamURL.absoluteString)

    } else {
      print("not found")
    }
  }

  public func toggle() {
    AudioPlayerClient.live.toggle()
  }
}

// MARK: - UIModel
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
