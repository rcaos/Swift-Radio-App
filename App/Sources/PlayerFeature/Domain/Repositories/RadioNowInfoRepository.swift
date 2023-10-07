//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

struct RadioStationNowInfoRepository {
  var getNowInfo: (_ radioStatio: RadioStation) async throws -> RadioStationNowInfo
}
