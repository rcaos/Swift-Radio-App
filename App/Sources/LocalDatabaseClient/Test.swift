//
//  Created by Jeans Ruiz on 25/09/23.
//

import Foundation

#if DEBUG
extension LocalDatabaseClient {
  public static var noop: LocalDatabaseClient = {
    return LocalDatabaseClient(
      toggleFavoriteStation: { _ in true },
      fetchAllFavorites: { [] },
      getStationById: { _ in nil }
    )
  }()
}
#endif
