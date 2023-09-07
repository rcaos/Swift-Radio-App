//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

extension RadioStationNowInfoRepository {
  static func live(
    rppDataSource: RadioStationNowInfoRPPDataSource
  ) -> RadioStationNowInfoRepository {
    return RadioStationNowInfoRepository(getNowInfo: {
      switch $0.type {
      case .RPP:
        return try await rppDataSource.getNowInfo($0.id).toDomain()
      case .other:
        return .init(description: "Online")
      }
    })
  }
}
