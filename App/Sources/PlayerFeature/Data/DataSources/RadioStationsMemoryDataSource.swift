//
//  Created by Jeans Ruiz on 7/09/23.
//

import Foundation

extension RadioStationsRemoteDataSource {
  static let memoryDataSource: RadioStationsRemoteDataSource = {

    let memoryStations: [RadioStationRemote] = [
      .init(
        id: "47",
        name: "Studio 92",
        description: "Número 1 en tu música",
        audioStreamURL: URL(string: "https://mdstrm.com/audio/5fada553978fe1080e3ac5ea/icecast.audio")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1")!,
        type: .RPP
      ),
      .init(
        id: "94421162-729F-47B7-983D-B7F40497662A",
        name: "RPP",
        description: "Confianza por todos los medios",
        audioStreamURL: URL(string: "http://cassini.shoutca.st:9300/stream")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/f8du4p4c7n90axt/rpp.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "06EDB6E9-EE8B-426A-A915-12FAC490766B",
        name: "Onda Cero",
        description: "Te mereces esta radio",
        audioStreamURL: URL(string: "http://strm112.1.fm/acountry_mobile_mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/jpxaene22p6wmag/ondacero.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "30A4A9BE-93DA-4433-BDF3-8921601896DA",
        name: "Exitosa - always Error",
        description: "La voz que integra al Perú",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ijfg0efnuvsz4eq/radioexitosa2.jpg?dl=1")!,
        type: .other
      )
    ]

    return RadioStationsRemoteDataSource(
      getAllStations: {
        return memoryStations
      },
      getStationById: { id in
        return memoryStations.first(where: { $0.id == id })
      }
    )
  }()
}
