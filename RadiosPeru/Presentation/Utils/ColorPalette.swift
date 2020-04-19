//
//  ColorPalette.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(withIntRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
    
    let floatRed = CGFloat(red)/255
    let floatGreen = CGFloat(green)/255
    let floatBlue = CGFloat(blue)/255
    
    self.init(red: floatRed, green: floatGreen, blue: floatBlue, alpha: alpha)
  }
}

struct ColorPalette {
  
  static let customGrayColor = UIColor(withIntRed: 40, green: 40, blue: 40, alpha: 1.0)
}
