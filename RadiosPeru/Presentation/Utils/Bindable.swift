//
//  Bindable.swift
//  RadiosPeru
//
//  Created by Jeans on 10/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

class Bindable<Type> {
  typealias Listener = (Type) -> Void
  var listener: Listener?
  
  var value: Type {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: Type) {
    self.value = value
  }
  
  func bind(_ listener: Listener?) {
    self.listener = listener
  }
  
  func bindAndFire(_ listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
  
}
