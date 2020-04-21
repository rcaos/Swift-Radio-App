//
//  String+Localizable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public extension String {

  func localized(tableName: String = "Localizable") -> String {
    return NSLocalizedString("\(self)", comment: "A comment of localization")
  }
}
