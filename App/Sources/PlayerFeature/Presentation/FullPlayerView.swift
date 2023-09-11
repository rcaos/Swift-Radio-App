//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation
import SwiftUI

private let fullImageURL = URL(string: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1")!

public struct FullPlayerView: View {

  #warning("todo, change namimg, model, store?")
  @Environment(PlayerViewModel.self) private var playerModel

  public init() { }

  public var body: some View {
    if let model = playerModel.selectedStation {
      VStack {
        VStack {
          // todo, fix size
          AsyncImage(url: model.imageURL)
          //foo()
            .clipShape(.rect(cornerRadius: 8))

          Slider(value: .constant(5))
        }
        .padding([.leading, .trailing])


        VStack {
          Text(model.title)
            .lineLimit(1)
            .font(.title)
            .fontWeight(.bold)
          Text(model.subtitle)
            .lineLimit(1)
            .font(.body)
        }
        .padding([.top])

        HStack {
          Spacer()
          Button(action: {}, label: {
            Label("", systemImage: model.state.isPlaying ? "chart.bar.fill": "chart.bar")
          })
          .opacity( model.state.isLoading ? 0 : 1)
          .overlay {
            if model.state.isLoading {
              ProgressView().id(UUID())
            }
          }

          Spacer()

          Button(action: {
            playerModel.toggle()
          }, label: {
            Image(systemName: model.state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
              .resizable()
              .scaledToFit()
              .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
              .frame(width: 88, height: 88)
          })

          Spacer()

          Button(action: {

          }, label: {
            Image(systemName: model.isFavorite ? "heart.fill" : "heart")
              .resizable()
              .scaledToFit()
              .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
              .frame(width: 44, height: 44)
          })

          Spacer()
        }
        .padding([.leading, .top, .trailing])
      }
    } else {
      EmptyView()
    }

  }
}

#Preview {
  let factory = PlayerFactory()

  struct PlayerFactory {
    func foo() -> FetchNowInfoUseCase {
      return FetchNowInfoUseCaseFactory.build(apiClient: .noop)
    }

    func foo2() -> FetchAllRadioStations {
      return FetchAllRadioStationsFactory.build()
    }

    func foo3() -> GetRadioStationById {
      return GetRadioStationByIdFactory.build()
    }

  }

  let playerViewModel = PlayerViewModel(
    fetchNowInfoUseCase: { factory.foo() },
    fetchAllRadioStations: { factory.foo2() },
    getRadioStationById: { factory.foo3() }
  )

  playerViewModel.selectedStation = .init(
    title: "Moda FM",
    subtitle: "Lima - 97.3 FM Música continuada"
  )

  return FullPlayerView()
    .environment(playerViewModel)
  //.preferredColorScheme(.dark)
}

func foo() -> Image {
  return convertBase64StringToImage(imageBase64String: imageBase)
}

private func convertBase64StringToImage(imageBase64String: String) -> Image {
  let imageData = Data(base64Encoded: imageBase64String)!
  let uImage = UIImage(data: imageData)!

  return Image(uiImage: uImage)
}

let imageBase = "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQEBAQIBAQECAgICAgQDAgICAgUEBAMEBgUGBgYFBgYGBwkIBgcJBwYGCAsICQoKCgoKBggLDAsKDAkKCgr/2wBDAQICAgICAgUDAwUKBwYHCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgr/wAARCADIAMgDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD4booor5c/2ECiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAAnHNSPaXEcPnyRMF3Y3FTg/j0PUfnXsf7Cv7E3xU/bq+ONj8JPhzAILVCJ/EWuyxloNIsg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HJx6UlfRH/BNX9nTwV8b/wBoGPxZ8bNUg0z4afD+y/4SP4h6re/LBHZQODHbse7Ty7IwgyzDeACeKai5yUVu/wCvw3POzfNMNkmV1swxF3ClFyaWrb6RiuspO0YrdyaR+pv/AASS+CPw4/4Jt/8ABP8Avv2n/wBoe/g8P3/i21j1vxDe3qYktLDbixtAv3mkZX3+WvzNJPtxxX5g/wDBSv8A4KSfEj/goL8Vxqd4s+leCNFmdPCfhjzTiJTwbqfBw9w44J6IPkX+Ittf8FS/+CnXjX9vj4jDQvDsVxovw28P3TDwz4fJ2NcMMr9suVHBlZfur0iQ7R8xZj8nfjXTXxClFUqfwL8f+AfkXhz4dYnD5vW4v4jipZliW5KL1VCL0UF/fUbRb+ylyr7TkU5JCnYH6im0VyNJ7n7epOLuhzyO/fH0oWTAwwDD/aGabRRyqw+ed73HmbjaqAA9QBijzu5QH3IplFLlj2K9rPuPaeRsZY8dOaRZSOoB+optFPliLnne9xxlfOQacJwTl41YnqSozUdFLli+gKpNPRkhupic7z+dSrqVwq7d7dOOarUU7IpV6qd0yX7VIW3FjU41m7AwJW/OqdFFkOOIqwejLUurXL/IZmPtmqzMWOTSUUWSJqVZ1PiYUUUUzMKKKKACiiigABwc11g+MPii1+Ex+DGj3BstFutWGp6xDATnU7lVKQtMf4lhUsI0+6pkd8FmyOTooM6lKjWUVUipWakr9Gtn6rddnrugooooNAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAP//Z"
