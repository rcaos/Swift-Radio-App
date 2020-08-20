//
//  UIImageView+Kingfisher.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Kingfisher

extension UIImageView {
  
  func setImage(with url: URL?, placeholder: UIImage? = nil) {
    kf.indicatorType = .activity
    kf.setImage(with: url, placeholder: placeholder)
  }
}
