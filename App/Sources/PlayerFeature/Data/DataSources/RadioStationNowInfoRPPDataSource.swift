//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

struct RadioStationNowInfoRPPDataSource {
  var getNowInfo: (_ radioId: String) async throws -> RadioStationRPPDTO
}
