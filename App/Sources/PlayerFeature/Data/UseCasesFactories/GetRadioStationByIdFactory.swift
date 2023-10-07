//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation
import LocalDatabaseClient

public struct GetRadioStationByIdFactory {
  public static func build(
    localDatabaseClient: LocalDatabaseClient
  ) -> GetRadioStationById {
    return .live(
      radioStationsRepository: .live(remoteDataSource: .memoryDataSource, localDatabaseClient: localDatabaseClient)
    )
  }
}
