//
//  Created by Jeans Ruiz on 17/08/23.
//

import Foundation

struct RadioStationsRepository {
  var getAllStations: () async -> [RadioStation]

  var getStationById: (String) async -> RadioStation?
}
