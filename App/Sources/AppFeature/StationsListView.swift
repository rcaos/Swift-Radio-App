//
//  Created by Jeans Ruiz on 15/08/23.
//

import Foundation
import SwiftUI
import PlayerFeature

public struct StationsListView: View {
  @Environment(PlayerModel.self) private var playerModel

  let colums = [
    GridItem(.flexible()), 
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  public init() { }

  public var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        LazyVGrid(columns: colums, content: {
          ForEach(playerModel.stations, id: \.self) { station in
            AsyncImage(
              url: station.pathImageURL,
              content: {
                $0.resizable()
                  .aspectRatio(contentMode: .fit)
                  .clipShape(.rect(cornerRadius: 8))
                  .frame(height: 131)
              },
              placeholder: {
                ProgressView()
              }
            )
            .frame(height: 131)
            .onTapGesture { 
              Task {
                await playerModel.loadStation(stationId: station.id)
              }
            }
          }
        })
        .padding([.leading, .trailing])
      }

      if playerModel.selectedStation != nil {
        MiniPlayerView()
      }
    }
    .task {
      await playerModel.onAppear()
    }
  }
}

#Preview {
  let player = PlayerModel.test(
    fetchAllRadioStations: { FetchAllRadioStationsFactory.build(localDatabaseClient: .mock()) }
  )

  return StationsListView()
    .environment(player)
    .preferredColorScheme(.dark)

  return StationsListView()
    .environment(player)
    .preferredColorScheme(.dark)
}

#Preview {
  let player = PlayerModel.test(
    fetchAllRadioStations: { FetchAllRadioStationsFactory.build(localDatabaseClient: .mock()) }
  )

  return StationsListView()
    .environment(player)
    .preferredColorScheme(.light)
}
