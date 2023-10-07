//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

struct RadioFavoritesStationsRepository {
  var toggleFavoriteStation: (RadioStationFavorite) async -> Bool

  var fetchAllFavorites: () async -> [RadioStationFavorite]
}
