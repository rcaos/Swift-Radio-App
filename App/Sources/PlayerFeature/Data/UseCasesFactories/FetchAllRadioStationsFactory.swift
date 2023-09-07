//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

public struct FetchAllRadioStationsFactory {
  public static func build() -> FetchAllRadioStations {
    return .live(radioStationsRepository: .live(dataSource: .memoryDataSource))
  }
}
