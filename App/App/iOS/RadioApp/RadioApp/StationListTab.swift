//
//  Created by Jeans Ruiz on 11/09/23.
//

import AppFeature
import Env
import Foundation
import SwiftUI

struct StationListTab: View {
  @State private var routerPath = RouterPath()

  var body: some View {
    NavigationStack {
      StationsListView()
        .navigationTitle("Radio app")
        .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
    }
    .environment(routerPath) // todo router is @State
  }
}
