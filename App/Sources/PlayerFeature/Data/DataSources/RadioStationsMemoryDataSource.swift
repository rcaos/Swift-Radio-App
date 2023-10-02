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
        id: "2",
        name: "RPP",
        description: "Confianza por todos los medios",
        audioStreamURL: URL(string: "http://cassini.shoutca.st:9300/stream")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/f8du4p4c7n90axt/rpp.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "3",
        name: "Onda Cero",
        description: "Te mereces esta radio",
        audioStreamURL: URL(string: "http://strm112.1.fm/acountry_mobile_mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/jpxaene22p6wmag/ondacero.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "4",
        name: "Capital",
        description: "Tu Opinion Importa",
        audioStreamURL: URL(string: "https://16693.live.streamtheworld.com/RADIO_CAPITAL.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/4kwsmyog8w4bc67/capital.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "5",
        name: "Corazón",
        description: "Única como tú",
        audioStreamURL: URL(string: "https://17523.live.streamtheworld.com/RADIO_CORAZON.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/x1k1z50z7t1lkz1/corazon.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "6",
        name: "Oxígeno",
        description: "Clásicos del rock & pop",
        audioStreamURL: URL(string: "https://20813.live.streamtheworld.com/RADIO_OXIGENO.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/f6wgi3qeh7x5jyp/oxigeno.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "7",
        name: "La Zona",
        description: "¡Tu música urbana!",
        audioStreamURL: URL(string: "https://15383.live.streamtheworld.com/RADIO_LAZONA.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/e2gwyb55l0u3k31/lazona.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "8",
        name: "Felicidad",
        description: "La música de tu vida",
        audioStreamURL: URL(string: "https://18313.live.streamtheworld.com/RADIO_FELICIDAD.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/k7szd80iamwos8g/felicidad.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "9",
        name: "Ritmo Romantica",
        description: "Tu radio de baladas",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/bpb79j1lbkqxfzf/romantica.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "10",
        name: "Moda",
        description: "Te mueve! ... con la música que esta de moda",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/mhofkfrvce96zf6/moda.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "11",
        name: "Oasis",
        description: "Te mueve! ... con la música que esta de moda",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/zffkjbpupaf6dul/oasis.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "12",
        name: "Nueva Q",
        description: "Te mueve! ... con la música que esta de moda",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/nqqd4xwjfffti8e/nuevaq.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "13",
        name: "Zeta Rock & Pop",
        description: "La marca de la buena música",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/e5z8p8v8cvywq95/zetaRockPoop.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "14",
        name: "Exitosa",
        description: "La Radio del Perú",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ijfg0efnuvsz4eq/radioexitosa2.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "15",
        name: "Onda Cero",
        description: "¡Te activa!",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/jpxaene22p6wmag/ondacero.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "16",
        name: "Panamericana",
        description: "¡Lo que el Perú quiere escuchar!",
        audioStreamURL: URL(string: "https://19253.live.streamtheworld.com/CRP_RIT.mp3")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ahamn6h0j25qdxj/panamericana2.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "17",
        name: "La Kalle",
        description: "¡Qué te vas a equivocar!",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ygnwl1uik3c2ml4/lakalle.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "18",
        name: "La Inolvidable",
        description: "Tus mejores momentos",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/4ksc402jvkf46yc/inolvidable.jpg?dl=1")!,
        type: .other
      ),
      .init(
        id: "19",
        name: "Planeta",
        description: "Tu música en inglés",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/ehz5emcw3tmnxhb/planeta.png?dl=1")!,
        type: .other
      ),
      .init(
        id: "20",
        name: "¡Vive gozando!",
        description: "Tu música en inglés",
        audioStreamURL: URL(string: "http://mock.com")!,
        pathImageURL: URL(string: "https://www.dropbox.com/s/0d2r6ovlk32j20c/radiomar.jpg?dl=1")!,
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
