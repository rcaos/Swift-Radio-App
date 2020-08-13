//
//  MainCoordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public protocol MainCoordinatorDelegate: class {
  func mainCoordinatorDidFinish()
}

public enum MainSteps: Step {
  case
  
  mainSceneIsRequired,
  
  mainSceneDidFinish
}

public protocol MainCoordinatorDependencies {
  
  func buildMainViewController() -> UIViewController
}

public class MainCoordinator: NavigationCoordinator {
  
  public var navigationController: UINavigationController
  
  weak var delegate: MainCoordinatorDelegate?
  
  private let dependencies: MainCoordinatorDependencies
  
  // MARK: - Life Cycle
  
  public init(navigationController: UINavigationController, dependencies: MainCoordinatorDependencies) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  public func start(with step: MainSteps) {
    navigate(to: step)
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: MainSteps) {
    switch step {
    case .mainSceneIsRequired:
      showMainScene()
      
    case .mainSceneDidFinish:
      // TODO, asignar al VC deinit
      delegate?.mainCoordinatorDidFinish()
    }
  }
  
  fileprivate func showMainScene() {
    let mainVC = dependencies.buildMainViewController()
    navigationController.setViewControllers([mainVC], animated: true)
  }
}
