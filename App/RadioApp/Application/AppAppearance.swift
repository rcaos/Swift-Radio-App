//
//  AppAppearance.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class AppAppearance {
  
  static func setupAppearance() {
    
    UIFont.loadFonts()
    
    UINavigationBar.appearance().barTintColor = ColorPalette.customGrayColor
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().prefersLargeTitles = false
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: Font.proximaNova.of(type: .bold, with: .normal)]
    
    UITabBar.appearance().barTintColor = ColorPalette.customGrayColor
    UITabBar.appearance().tintColor = .white
    
    UITabBarItem.appearance().setTitleTextAttributes(
      [NSAttributedString.Key.font: Font.proximaNova.of(type: .bold, with: .custom(10) )], for: .normal)
  }
}

extension UINavigationController {
  
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
