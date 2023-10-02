//
//  Created by Jeans Ruiz on 24/09/23.
//

import Foundation
import PlayerFeature
import SwiftUI

public struct FavoritesListView: View {

  @Environment(PlayerViewModel.self) private var playerManager

  public init() { }

  public var body: some View {
    VStack(alignment: .leading) {
      if playerManager.favoriteStations.count > 0 {
        List(playerManager.favoriteStations, id: \.self) { station in
          VStack(alignment: .leading) {
            Text(station.name)
            Text(station.description)
          }
        }
      } else {
        Text("The Favorites Stations will appear here")
      }
    }
    .task {
      await playerManager.loadFavorites()
    }
  }
}

#if DEBUG
import LocalDatabaseClient

#Preview {

  let dataBase = LocalDatabaseClient.mock(fetchAllFavorites: {
    return [
      .init(
        id: "mock1",
        name: "RPP",
        description: "La Radio del Perú",
        pathImageURL: URL(string: "https://www.dropbox.com/s/hgxrkhe8ar40360/studio92.jpg?dl=1")!
      )
    ]
  })

  let player = PlayerViewModel.test(
    fetchAllFavorites: { FetchAllFavoriteRadiosUseCaseFactory.buildLocalUseCase(localDataBaseClient: dataBase) }
  )

  return FavoritesListView()
    .environment(player)
    .preferredColorScheme(.dark)
}
#endif
