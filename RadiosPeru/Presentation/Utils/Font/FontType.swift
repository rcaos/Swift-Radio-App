//
//  FontType.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public enum FontType: String, CaseIterable {
  case
  thin = "Thin",
  regular = "Regular",
  bold = "Bold"
  
  internal func of(family: Font, size: FontSize = .normal) -> UIFont {
    switch self {
    case .thin:
      return family == .proximaNova ?
        UIFont(name: "\(family.rawValue)T-Thin", size: size.value)! :
        UIFont.systemFont(ofSize: size.value, weight: .thin)
    case .regular:
      return family == .proximaNova ?
        UIFont(name: "\(family.rawValue)-Regular", size: size.value)! :
        UIFont.systemFont(ofSize: size.value, weight: .regular)
    case .bold:
      return family == .proximaNova ?
        UIFont(name: "\(family.rawValue)-Bold", size: size.value)! :
        UIFont.systemFont(ofSize: size.value, weight: .bold)
    }
  }
}
