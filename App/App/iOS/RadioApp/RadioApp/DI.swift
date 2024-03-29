//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation
import LocalDatabaseClient
import Networking
import NetworkingLive
import PlayerFeature
import SwiftData

private struct PlayerFactory {

  private let modelContext: ModelContext
  private let localDatabaseClient: LocalDatabaseClient
  private let apiClientRPPLive = ApiClient.live(networkConfig: .init(baseURL: URL(string: "https://radio.rpp.pe")!))

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    self.localDatabaseClient = .buildSwiftDataClient(modelContext: modelContext)
  }

  func buildFetchNowUseCase() -> FetchNowInfoUseCase {
    return FetchNowInfoUseCaseFactory.build(apiClient: apiClientRPPLive)
  }

  func buildFetchAllStationsUseCase() -> FetchAllRadioStations {
    return FetchAllRadioStationsFactory.build(
      remoteDataSource: .memoryDataSource,
      localDatabaseClient: localDatabaseClient
    )
  }

  func buildGetStationByIdUseCase() -> GetRadioStationById {
    return GetRadioStationByIdFactory.build(localDatabaseClient: localDatabaseClient)
  }

  func buildToggleRadioStationFavoriteUseCase() -> ToggleRadioStationFavoriteUseCase {
    return ToggleRadioStationUseCaseFactory.buildLocalUseCase(localDataBaseClient: localDatabaseClient)
  }

  func buildFetchAllFavoriteRadiosUseCase() -> FetchAllFavoriteRadiosUseCase {
    FetchAllFavoriteRadiosUseCaseFactory.buildLocalUseCase(localDataBaseClient: localDatabaseClient)
  }
}

// MARK: TODO, expose this
extension PlayerModel {
  static func buildShared(modelContext: ModelContext) -> PlayerModel {

    let factory = PlayerFactory(modelContext: modelContext)

    return .init(
      fetchNowInfoUseCase: { factory.buildFetchNowUseCase() },
      fetchAllRadioStations: { factory.buildFetchAllStationsUseCase() },
      getRadioStationById: { factory.buildGetStationByIdUseCase() },
      toggleFavoriteRadioStationUseCase: { factory.buildToggleRadioStationFavoriteUseCase() },
      fetchAllFavorites: { factory.buildFetchAllFavoriteRadiosUseCase() }
    )
  }
}

func buildModelContainer() -> ModelContainer {
  let schema = Schema([
    RadioStationFavoriteSD.self
  ])
  let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

  do {
    return try ModelContainer(for: schema, configurations: [configuration])
  } catch  {
    fatalError("ModelContainer cannot created")
  }
}
