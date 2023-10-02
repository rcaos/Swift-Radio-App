//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

public struct RadioStationsRemoteDataSource {
  var getAllStations: () async -> [RadioStationRemote]

  var getStationById: (String) async -> RadioStationRemote?
}

struct RadioStationRemote: Hashable {
  let id: String
  let name: String
  let description: String
  let audioStreamURL: URL
  let pathImageURL: URL
  let type: RadioStation.RadioStationType

  init(
    id: String,
    name: String,
    description: String,
    audioStreamURL: URL,
    pathImageURL: URL,
    type: RadioStation.RadioStationType
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.audioStreamURL = audioStreamURL
    self.pathImageURL = pathImageURL
    self.type = type
  }
}
