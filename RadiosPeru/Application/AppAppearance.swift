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
    
    let customColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
    
    UINavigationBar.appearance().barTintColor = customColor
    UINavigationBar.appearance().prefersLargeTitles = false
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
    UITabBar.appearance().barTintColor = customColor
    UITabBar.appearance().tintColor = .white
  }
}

extension UINavigationController {
  
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
