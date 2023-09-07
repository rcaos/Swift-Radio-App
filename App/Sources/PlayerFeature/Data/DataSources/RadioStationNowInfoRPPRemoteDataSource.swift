//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation
import Networking

extension RadioStationNowInfoRPPDataSource {
  static func remote(apiClient: ApiClient) -> RadioStationNowInfoRPPDataSource {
    return RadioStationNowInfoRPPDataSource(getNowInfo: {
      let endpoint = Endpoint(
        path: "now/live",
        method: .get,
        queryParameters: ["rpIds": $0]
      )
      return try await apiClient.apiRequest(endpoint: endpoint, as: RadioStationRPPDTO.self)
    })
  }
}

// MARK: - DTO
struct RadioStationRPPDTO: Decodable {
  let results: ResultDTO

  struct ResultDTO: Decodable {
    let pi: PI

    enum CodingKeys: String, CodingKey {
      case pi = "PI"
    }

    struct PI: Decodable {
      let description: String
    }
  }

  func toDomain() -> RadioStationNowInfo {
    return .init(description: results.pi.description)
  }
}
