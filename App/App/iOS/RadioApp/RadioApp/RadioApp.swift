//
//  Created by Jeans Ruiz on 11/08/23.
//

import PlayerFeature
import SwiftUI

@main
struct RadioApp: App {
  private let playerViewModel = PlayerViewModel.shared

  var body: some Scene {
    WindowGroup {
      TabView {
        StationListTab()
          .tabItem {
            Label("Home", systemImage: "house")
          }
          .environment(playerViewModel)

        FavoritesTab()
          .tabItem {
            Label("Favorites", systemImage: "star")
          }
          .environment(playerViewModel)
      }
    }
  }
}
