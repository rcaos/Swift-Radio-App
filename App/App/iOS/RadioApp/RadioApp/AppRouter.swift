//
//  Created by Jeans Ruiz on 11/09/23.
//

import Env
import Foundation
import PlayerFeature
import SwiftUI

extension View {

  func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
    sheet(item: sheetDestinations) {
      switch $0 {
      case .fullPlayer:
        FullPlayerView()
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
    }
  }
}
