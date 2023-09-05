//
//  Created by Jeans Ruiz on 11/08/23.
//

import AppFeature
import PlayerFeature
import SwiftUI

@main
struct RadioAppApp: App {

  private let playerViewModel = PlayerViewModel()

  var body: some Scene {
    WindowGroup {
      TabView {
        StationsListView()
          .tabItem {
            Label("Home", systemImage: "house")
          }
          .environment(playerViewModel)

        Text("Favorites here")
          .tabItem {
            Label("Favorites", systemImage: "star")
          }
      }
    }
  }
}
