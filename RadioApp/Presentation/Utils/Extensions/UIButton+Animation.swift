//
//  UIButton+Animation.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/15/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public extension UIButton {
  
  typealias CompletionHandler = (() -> Void)?
  
  func favAnimate(_ completion: CompletionHandler = nil) {
    transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    UIView.animate(
      withDuration: 0.6,
      delay: 0.1,
      usingSpringWithDamping: CGFloat(0.2),
      initialSpringVelocity: CGFloat(6.0),
      options: .allowUserInteraction,
      animations: { [weak self] in
        self?.transform = .identity
      }, completion: { _ in
        completion?()
    }
    )
  }
}
