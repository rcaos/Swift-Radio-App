//
//  Created by Jeans Ruiz on 14/08/23.
//

import Foundation
import AudioPlayerClient
import AsyncAlgorithms

public struct RadioStationUiModel: Hashable {
  public let id: String
  public let pathImageURL: URL

  public init(
    id: String,
    pathImageURL: URL
  ) {
    self.id = id
    self.pathImageURL = pathImageURL
  }

  public init(_ domain: RadioStation) {
    self.id = domain.id
    self.pathImageURL = domain.pathImageURL
  }
}

public struct RadioStationFavoriteUiModel: Hashable {
  public let id: String
  public let name: String
  public let description: String
  public let pathImageURL: URL

  public init(
    id: String,
    name: String,
    description: String,
    pathImageURL: URL
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.pathImageURL = pathImageURL
  }

  public init(_ domain: RadioStationFavorite) {
    self.id = domain.id
    self.name = domain.name
    self.description = domain.description
    self.pathImageURL = domain.pathImageURL
  }
}

@Observable public class PlayerModel {
  private var stationsModel: [RadioStation] = []
  
  public var stations: [RadioStationUiModel] = []
  public var favoriteStations: [RadioStationFavoriteUiModel] = []
  public var selectedStation: MiniPlayerUIModel? // todo, change to private set

  private let fetchNowInfoUseCase: () -> FetchNowInfoUseCase
  private let fetchAllRadioStations: () -> FetchAllRadioStations
  private let getRadioStationById: () -> GetRadioStationById
  private let toggleFavoriteRadioStationUseCase: () -> ToggleRadioStationFavoriteUseCase
  private let fetchAllFavorites: () -> FetchAllFavoriteRadiosUseCase

  public init(
    fetchNowInfoUseCase: @escaping () -> FetchNowInfoUseCase,
    fetchAllRadioStations: @escaping () -> FetchAllRadioStations,
    getRadioStationById: @escaping () -> GetRadioStationById,
    toggleFavoriteRadioStationUseCase: @escaping () -> ToggleRadioStationFavoriteUseCase,
    fetchAllFavorites: @escaping () -> FetchAllFavoriteRadiosUseCase
  ) {
    self.fetchNowInfoUseCase = fetchNowInfoUseCase
    self.fetchAllRadioStations = fetchAllRadioStations
    self.getRadioStationById = getRadioStationById
    self.toggleFavoriteRadioStationUseCase = toggleFavoriteRadioStationUseCase
    self.fetchAllFavorites = fetchAllFavorites
  }

  #warning("call once???")
  public func onAppear() async {
    //stations = await fetchAllRadioStations().execute().map { .init($0) }
    stationsModel = await fetchAllRadioStations().execute()
    stations = stationsModel.map { .init($0) }

    #warning("todo, control this dependency")
    for await value in AudioPlayerClient.live.delegate().removeDuplicates() {
      switch value {
      case .changeStatus(let status):
        selectedStation?.state = status.playerStatusUIModel
      }
    }
  }

  public func loadFavorites() async {
    favoriteStations = await fetchAllFavorites().execute().map { .init($0) }
  }

  public func loadStation(stationId: String) async {
    if let station = await getRadioStationById().execute(stationId)  {
      selectedStation = .init(
        stationId: station.id,
        isFavorite: station.isFavorite,
        state: .loading,
        title: station.name,
        subtitle: station.description,
        imageURL: station.pathImageURL
      )
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

  public func toggleFavorite(stationId: String) async {
    if let found = stationsModel.first(where: { $0.id == stationId }) {
      let toToggle = RadioStationFavorite(found)
      let isFavorite = await toggleFavoriteRadioStationUseCase().execute(toToggle)
      selectedStation?.isFavorite = isFavorite
      await loadFavorites()
    }
  }
}

#warning("todo, move it")
extension RadioStationFavorite {

  public init(_ domain: RadioStation) {
    self.init(
      id: domain.id,
      name: domain.name,
      description: domain.description,
      pathImageURL: domain.pathImageURL
    )
  }
}
