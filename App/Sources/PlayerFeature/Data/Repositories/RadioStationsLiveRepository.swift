//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

extension RadioStationsRepository {
  static func live(
    dataSource: RadioStationsDataSource
  ) -> RadioStationsRepository {

    return RadioStationsRepository(
      getAllStations: dataSource.getAllStations,
      getStationById: {
        return await dataSource.getStationById($0)
      }
    )
  }
}
