//
//  Created by Jeans Ruiz on 2/10/23.
//

import Foundation
import XCTestDynamicOverlay

#if DEBUG
extension PlayerViewModel {

  public static func test(
    fetchNowInfoUseCase: @escaping () -> FetchNowInfoUseCase = { unimplemented("fetchNowInfoUseCase") },
    fetchAllRadioStations: @escaping () -> FetchAllRadioStations = { unimplemented("fetchAllRadioStations") },
    getRadioStationById: @escaping () -> GetRadioStationById = { unimplemented("getRadioStationById") },
    toggleFavoriteRadioStationUseCase: @escaping () -> ToggleRadioStationFavoriteUseCase = { unimplemented("toggleFavoriteRadioStationUseCase") },
    fetchAllFavorites: @escaping () -> FetchAllFavoriteRadiosUseCase = { unimplemented("fetchAllFavorites") }
  ) -> PlayerViewModel {
    return PlayerViewModel(
      fetchNowInfoUseCase: fetchNowInfoUseCase,
      fetchAllRadioStations: fetchAllRadioStations,
      getRadioStationById: getRadioStationById,
      toggleFavoriteRadioStationUseCase: toggleFavoriteRadioStationUseCase,
      fetchAllFavorites: fetchAllFavorites
    )
  }
}
#endif
