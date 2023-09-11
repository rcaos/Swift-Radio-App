//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation
import Networking
import NetworkingLive
import PlayerFeature

private let apiClientRPPLive = ApiClient.live(networkConfig: .init(baseURL: URL(string: "https://radio.rpp.pe")!))

private let factory = PlayerFactory()

private struct PlayerFactory {
  func buildFetchNowUseCase() -> FetchNowInfoUseCase {
    return FetchNowInfoUseCaseFactory.build(apiClient: apiClientRPPLive)
  }

  func buildFetchAllStationsUseCase() -> FetchAllRadioStations {
    return FetchAllRadioStationsFactory.build()
  }

  func buildGetStationByIdUseCase() -> GetRadioStationById {
    return GetRadioStationByIdFactory.build()
  }
}

// MARK: TODO, expose this
extension PlayerViewModel {
  static var shared: PlayerViewModel = {
    return .init(
      fetchNowInfoUseCase: { factory.buildFetchNowUseCase() },
      fetchAllRadioStations: { factory.buildFetchAllStationsUseCase() },
      getRadioStationById: { factory.buildGetStationByIdUseCase() }
    )
  }()
}
