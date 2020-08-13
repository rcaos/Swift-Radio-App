//
//  Coordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

public protocol Coordinator: class {
  
  func start(with step: Step)
  
  func start()
}

public extension Coordinator {

  func start(with step: Step = DefaultStep() ) { }
  
  func start() { }
}

// MARK: - Steps

/// Describe un posible estado de navegación dentro de un Coordinator

public protocol Step { }

public struct DefaultStep: Step {
  public init() { }
}
