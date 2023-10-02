//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation
import LocalDatabaseClient

public struct FetchAllRadioStationsFactory {
  public static func build(
    remoteDataSource: RadioStationsRemoteDataSource,
    localDatabaseClient: LocalDatabaseClient
  ) -> FetchAllRadioStations {
    return .live(
      radioStationsRepository: .live(remoteDataSource: remoteDataSource, localDatabaseClient: localDatabaseClient)
    )
  }
}
