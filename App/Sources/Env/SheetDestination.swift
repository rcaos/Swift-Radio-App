//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation

public enum SheetDestination: Identifiable {
  case fullPlayer

  public var id: String {
    switch self {
    case .fullPlayer:
      return "fullPlayer"
    }
  }
}
