//
//  InitialCoordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

// MARK: - TODO, separate files

public protocol InitialCoordinatorProtocol: class {
  
  func navigate(to step: InitialStep)
}

public protocol InitialCoordinatorDelegate: class {
  func initialCoordinatorDidFinish()
}

public enum InitialStep: Step {
  case
  
  initialSceneIsRequired,
  
  initialSceneDidFinish
}

public protocol InitialCoordinatorDependencies {
  
  func buildInitialViewController(coordinator: InitialCoordinatorProtocol?) -> UIViewController
}

public class InitialCoordinator: Coordinator, InitialCoordinatorProtocol {
  
  weak var delegate: InitialCoordinatorDelegate?
  
  private let tabBarController: UITabBarController
  
  private let dependencies: InitialCoordinatorDependencies
  
  // MARK: - Life Cycle
  
  public init(tabBarController: UITabBarController, dependencies: InitialCoordinatorDependencies) {
    self.tabBarController = tabBarController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start(with step: InitialStep) {
    navigate(to: step)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: InitialStep) {
    switch step {
    case .initialSceneIsRequired:
      showInitialFeature()
      
    case .initialSceneDidFinish:
      delegate?.initialCoordinatorDidFinish()
    }
  }
  
  fileprivate func showInitialFeature() {
    let initialVC = dependencies.buildInitialViewController(coordinator: self)
    tabBarController.setViewControllers([initialVC], animated: true)
  }
}
