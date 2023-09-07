//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

extension RadioStationsDataSource {
  static let memoryDataSource: RadioStationsDataSource = {

    let memoryStations: [RadioStation] = [
      .init(
        name: "RPP",
        audioStreamURL: URL(string: "http://cassini.shoutca.st:9300/stream")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/f8du4p4c7n90axt/rpp.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "47",
        name: "Studio 92",
        audioStreamURL: URL(string: "https://mdstrm.com/audio/5fada553978fe1080e3ac5ea/icecast.audio")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1")!,
        type: .RPP
      ),
      .init(
        name: "Onda Cero",
        audioStreamURL: URL(string: "http://strm112.1.fm/acountry_mobile_mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/jpxaene22p6wmag/ondacero.jpg?dl=1")!,
        type: .other
      ),
      .init(
        name: "Exitosa - always Error",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ijfg0efnuvsz4eq/radioexitosa2.jpg?dl=1")!,
        type: .other
      )
    ]

    return RadioStationsDataSource(
      getAllStations: {
        return memoryStations
      },
      getStationById: { id in
        return memoryStations.first(where: { $0.id == id })
      }
    )
  }()
}
