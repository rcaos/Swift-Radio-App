//
//  Created by Jeans Ruiz on 15/08/23.
//

import Foundation
import SwiftUI
import PlayerFeature

public struct StationsListView: View {
  @Environment(PlayerViewModel.self) private var model

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
          ForEach(model.stations, id: \.self) { station in
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
                await model.loadStation(stationId: station.id)
              }
            }
          }
        })
      }

      if model.selectedStation != nil {
        MiniPlayerView()
      }
    }
    .task {
      await model.onAppear()
    }
  }
}
