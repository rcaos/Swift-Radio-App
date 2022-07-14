//
//  FontSize.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public enum FontSize {
  case
  
  // A `12.0` size for a font.
  small,
  
  // A `14.0` size for a font.
  medium,
  
  // A `16.0` size for a font.
  normal,
  
  // A `20.0` size for a font.
  big,
  
  // A custom size for a font.
  custom(CGFloat)
  
  /// Variable that returns the size of a font.
  var value: CGFloat {
    switch self {
    case .small:
      return 12.0
    case .medium:
      return 14.0
    case .normal:
      return 16.0
    case .big:
      return 20.0
    case .custom(let size):
      return size
    }
  }
}
