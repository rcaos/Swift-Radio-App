//
//  Font.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public enum Font: String, CaseIterable {
  case
  proximaNova = "ProximaNova"
  
  @available(*, deprecated, message: "Use `rawValue` instead.")
  var resourceName: String {
    switch self {
    case .proximaNova:
      return "ProximaNova"
    }
  }
  
  public init() {
    self = .proximaNova
  }
  
  public func of(type: FontType, with size: FontSize) -> UIFont {
    return type.of(family: self, size: size)
  }
}
