//
//  UIFont+Loader.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

typealias FontName = String

public extension UIFont {
  
  static func loadFonts() {
    Font.allCases
      .forEach { font in
        FontType.allCases.forEach { fontType in
          loadFont(with: "\(font.rawValue)-\(fontType.rawValue)")
        }
    }
  }
  
  fileprivate static func loadFont(with name: FontName) {
    
    let frameworkBundle = Bundle.main
    let pathForResourceString = frameworkBundle.path(forResource: name, ofType: "otf")
    let fontData = NSData(contentsOfFile: pathForResourceString!)
    let dataProvider = CGDataProvider(data: fontData!)
    let fontRef = CGFont(dataProvider!)
    var errorRef: Unmanaged<CFError>? = nil

    if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
      NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
    }
  }
}
