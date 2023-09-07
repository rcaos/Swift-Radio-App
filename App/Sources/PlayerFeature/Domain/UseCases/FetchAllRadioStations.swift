//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

public struct FetchAllRadioStations {
  public var execute: () async -> [RadioStation]
}

extension FetchAllRadioStations {
  static func live(
    radioStationsRepository: RadioStationsRepository
  ) -> FetchAllRadioStations {
    return FetchAllRadioStations(execute: {
      return await radioStationsRepository.getAllStations()
    })
  }
}
