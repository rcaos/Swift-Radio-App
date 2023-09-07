//
//  Created by Jeans Ruiz on 14/08/23.
//

import Foundation
import AudioPlayerClient
import AsyncAlgorithms

#warning("Rename, this is not a ViewModel anymore")
@Observable public class PlayerViewModel {
  public var stations: [RadioStation] = []
  public var selectedStation: MiniPlayerUIModel?

  private let fetchNowInfoUseCase: () -> FetchNowInfoUseCase
  private let fetchAllRadioStations: () -> FetchAllRadioStations
  private let getRadioStationById: () -> GetRadioStationById

  public init(
    fetchNowInfoUseCase: @escaping () -> FetchNowInfoUseCase,
    fetchAllRadioStations: @escaping () -> FetchAllRadioStations,
    getRadioStationById: @escaping () -> GetRadioStationById
  ) {
    self.fetchNowInfoUseCase = fetchNowInfoUseCase
    self.fetchAllRadioStations = fetchAllRadioStations
    self.getRadioStationById = getRadioStationById
    print("init viewModel: \(Self.self)")
  }

  #warning("call once???")
  public func onAppear() async {
    stations = await fetchAllRadioStations().execute()

    for await value in AudioPlayerClient.live.delegate().removeDuplicates() {
      print("✅viewModel.event: \(value)")
      switch value {
      case .changeStatus(let status):
        selectedStation?.state = status.playerStatusUIModel
      }
    }
  }

  public func loadStation(stationId: String) async {
    if let station = await getRadioStationById().execute(stationId)  {
      if selectedStation == nil {
        selectedStation = .init(title: station.name)
      } else {
        selectedStation?.title = station.name
      }

      AudioPlayerClient.live.load(station.audioStreamURL.absoluteString)

      let radioInfo = await fetchNowInfoUseCase().execute(station)
      #warning("why this does not trigger a change in the UI?")
      selectedStation?.subtitle = radioInfo.description

    } else {
      print("not found")
    }
  }

  public func toggle() {
    AudioPlayerClient.live.toggle()
  }
}
