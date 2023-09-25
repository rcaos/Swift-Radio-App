//
//  Created by Jeans Ruiz on 11/09/23.
//

import AppFeature
import Env
import FavoritesFeature
import Foundation
import SwiftUI

struct FavoritesTab: View {

  @State private var routerPath = RouterPath()

  var body: some View {
    // Add a NavigationStack in case needed
    FavoritesListView()
      .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
      .environment(routerPath) // todo router is @State
  }
}
