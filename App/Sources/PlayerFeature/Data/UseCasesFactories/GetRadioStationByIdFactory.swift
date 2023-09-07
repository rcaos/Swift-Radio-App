//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

public struct GetRadioStationByIdFactory {
  public static func build() -> GetRadioStationById {
    return .live(radioStationsRepository: .live(dataSource: .memoryDataSource))
  }
}
