//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

public struct GetRadioStationById {
  public var execute: (String) async -> RadioStation?
}

extension GetRadioStationById {
  static func live(
    radioStationsRepository: RadioStationsRepository
  ) -> GetRadioStationById {
    return GetRadioStationById(execute: {
      return await radioStationsRepository.getStationById($0)
    })
  }
}
