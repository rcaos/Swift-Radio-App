//
//  Created by Jeans Ruiz on 17/08/23.
//

import Foundation

struct RadioStationsRepository {
  var getAllStations: () async -> [RadioStation]

  var getStationById: (String) -> RadioStation?
}

extension RadioStationsRepository {
  static let localRepository: RadioStationsRepository = {

    let memoryStations: [RadioStation] = [
      .init(
        name: "RPP",
        audioStreamURL: URL(string: "http://cassini.shoutca.st:9300/stream")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/f8du4p4c7n90axt/rpp.png?dl=1")!
      ),
      .init(
        name: "Onda Cero",
        audioStreamURL: URL(string: "http://strm112.1.fm/acountry_mobile_mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/jpxaene22p6wmag/ondacero.jpg?dl=1")!
      ),
      .init(
        name: "Exitosa - always Error",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ijfg0efnuvsz4eq/radioexitosa2.jpg?dl=1")!
      )
    ]

    return RadioStationsRepository(
      getAllStations: {
        return memoryStations
      },
      getStationById: { id in
        return memoryStations.first(where: { $0.id == id })
      }
    )
  }()

}

public struct RadioStation: Hashable {
  public let id: String
  public let name: String
  public let audioStreamURL: URL
  public let pathImageURL: URL

  init(
    id: String = UUID().uuidString,
    name: String,
    audioStreamURL: URL,
    pathImageURL: URL
  ) {
    self.id = id
    self.name = name
    self.audioStreamURL = audioStreamURL
    self.pathImageURL = pathImageURL
  }
}

//http://tunein-icecast.mediaworks.nz/rock_128kbps
//http://rfcmedia.streamguys1.com/classicrock.mp3
//http://104.250.149.122:8082/stream

//  .init(pathImage: "https://www.dropbox.com/s/4kwsmyog8w4bc67/capital.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/x1k1z50z7t1lkz1/corazon.png?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/f6wgi3qeh7x5jyp/oxigeno.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/e2gwyb55l0u3k31/lazona.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/k7szd80iamwos8g/felicidad.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/bpb79j1lbkqxfzf/romantica.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/4ksc402jvkf46yc/inolvidable.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/mhofkfrvce96zf6/moda.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/zffkjbpupaf6dul/oasis.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/0d2r6ovlk32j20c/radiomar.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/nqqd4xwjfffti8e/nuevaq.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/ehz5emcw3tmnxhb/planeta.png?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/btesr63gc0kjxav/cumbiamix.png?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/2whw62m3xhrk19b/karibena.png?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/e5z8p8v8cvywq95/zetaRockPoop.png?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/ijfg0efnuvsz4eq/radioexitosa2.jpg?dl=1"),
//  .init(pathImage: "https://www.dropbox.com/s/ygnwl1uik3c2ml4/lakalle.png?dl=1"),
//.init(pathImage: "https://www.dropbox.com/s/ahamn6h0j25qdxj/panamericana2.jpg?dl=1")
