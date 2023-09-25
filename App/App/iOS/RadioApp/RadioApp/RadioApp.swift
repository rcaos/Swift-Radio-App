//
//  Created by Jeans Ruiz on 11/08/23.
//

import PlayerFeature
import SwiftUI

@main
struct RadioApp: App {
  private let modelContainer = buildModelContainer()
  
  @MainActor
  private func buildPlayerManager() -> PlayerViewModel {
    return .buildShared(modelContext: modelContainer.mainContext)
  }
  
  var body: some Scene {
    WindowGroup {
      TabView {
        StationListTab()
          .tabItem {
            Label("Home", systemImage: "house")
          }
        
        FavoritesTab()
          .tabItem {
            Label("Favorites", systemImage: "star")
          }
      }
      //todo, find another way, is injected in all tabs"
      .environment(buildPlayerManager())
    }
  }
}
