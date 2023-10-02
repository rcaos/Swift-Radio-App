//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation
import SwiftUI

public struct FullPlayerView: View {
  @Environment(PlayerModel.self) private var playerModel

  public init() { }

  public var body: some View {
    if let model = playerModel.selectedStation {
      VStack {
        VStack (spacing: 16) {

          AsyncImage(url: model.imageURL, content: { image in
            image.resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxHeight: 300)
              .clipShape(.rect(cornerRadius: 16))
          }, placeholder: {
            ProgressView()
              .frame(maxHeight: 300)
          })

          #warning("only for Previews")
//          getLocalImage()
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(maxHeight: 300)
//            .clipShape(.rect(cornerRadius: 16))
        }
        .padding([.leading, .trailing])

        VStack {
          Text(model.title)
            .font(.title)
            .fontWeight(.bold)
          Text(model.subtitle)
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
            Task {
              await playerModel.toggleFavorite(stationId: model.stationId)
            }
          }, label: {
            Image(systemName: model.isFavorite ? "heart.fill" : "heart")
              .resizable()
              .scaledToFit()
              .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
              .frame(width: 44, height: 44)
          })

          Spacer()
        }
        .padding([.top])
      }
      .padding([.leading, .trailing])
    } else {
      EmptyView()
    }

  }
}

#Preview {
  let player = PlayerModel.test()

  player.selectedStation = .init(
    stationId: UUID().uuidString,
    isFavorite: false,
    state: .stopped,
    title: "Moda FM",
    subtitle: "Lima - 97.3 FM Música continuada, this is a Long Description, why are you doing this man????",
    imageURL: URL(string: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1")
  )

  return FullPlayerView()
    .environment(player)
    .tint(.green)
    .preferredColorScheme(.dark)
}
