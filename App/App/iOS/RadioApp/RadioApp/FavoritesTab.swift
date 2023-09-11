//
//  Created by Jeans Ruiz on 11/09/23.
//

import AppFeature
import Env
import Foundation
import SwiftUI

struct FavoritesTab: View {

  @State private var routerPath = RouterPath()

  var body: some View {
    // Add a NavigationStack in case needed
    Text("The Favorites Stations will show here")
      .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
      .environment(routerPath) // todo router is @State
  }
}
