//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation
import Networking

public struct FetchNowInfoUseCaseFactory {
  public static func build(apiClient: ApiClient) -> FetchNowInfoUseCase {
    let rppDataSource: RadioStationNowInfoRPPDataSource = .remote(apiClient: apiClient)
    let nowInfoRepository: RadioStationNowInfoRepository = .live(rppDataSource: rppDataSource)
    return .live(nowInfoRepository: nowInfoRepository)
  }
}
