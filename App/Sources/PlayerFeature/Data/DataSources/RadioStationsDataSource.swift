//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

struct RadioStationsDataSource {
  var getAllStations: () async -> [RadioStation]

  var getStationById: (String) async -> RadioStation?
}
