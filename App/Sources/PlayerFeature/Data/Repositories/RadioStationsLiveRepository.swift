//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation
import LocalDatabaseClient

extension RadioStationsRepository {
  static func live(
    remoteDataSource: RadioStationsRemoteDataSource,
    localDatabaseClient: LocalDatabaseClient
  ) -> RadioStationsRepository {

    return RadioStationsRepository(
      getAllStations: {
        let remoteStations = await remoteDataSource.getAllStations()
        let local = await localDatabaseClient.fetchAllFavorites()

        var stations: [RadioStation] = []
        for remote in remoteStations {
          let isFavorite = local.first(where: { $0.id == remote.id }) != nil
          stations.append(
            RadioStation(remoteStation: remote, isFavorite: isFavorite)
          )
        }
        dump(remoteStations, name: "RemoteStations:")
        dump(local, name: "Local:")
        dump(stations, name: "Domain:")
        return stations
      },
      getStationById: {
        if let remote = await remoteDataSource.getStationById($0) {
          dump(remote, name: "Remote:")
          let isFavorite = await localDatabaseClient.getStationById($0) != nil
          dump(isFavorite, name: "IsFavorite:")
          return RadioStation(remoteStation: remote, isFavorite: isFavorite)
        } else {
          return nil
        }
      }
    )
  }
}

// Convenience init
extension RadioStation {
  init(remoteStation: RadioStationRemote, isFavorite: Bool) {
    self.id = remoteStation.id
    self.name = remoteStation.name
    self.description = remoteStation.description
    self.audioStreamURL = remoteStation.audioStreamURL
    self.pathImageURL = remoteStation.pathImageURL
    self.isFavorite = isFavorite
    self.type = remoteStation.type
  }
}
