//
//  AppCoordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public enum AppChildCoordinator {
  case
  
  initial,
  
  main
}

public enum AppSteps {
  
  case
  
  initialSceneIsRequired,
  
  mainSceneIsRequired
}

class AppCoordinator: Coordinator {
  
  private let window: UIWindow
  
  private var childCoordinators = [AppChildCoordinator: Coordinator]()
  
  private let appDIContainer: AppDIContainer
  
  // MARK: - Initializer
  
  public init(window: UIWindow, appDIContainer: AppDIContainer) {
    self.window = window
    self.appDIContainer = appDIContainer
  }
  
  func start() {
    navigate(to: .initialSceneIsRequired)
  }
  
  // MARK: - Navigation
  
  fileprivate func navigate(to step: AppSteps) {
    switch step {
    case .initialSceneIsRequired:
      navigateToInitialFlow()
      
    case .mainSceneIsRequired:
      navigateToMainFlow()
    }
  }
  
  fileprivate func navigateToInitialFlow() {
    let tabBar = UITabBarController()
    let dependencies = appDIContainer.makeInitialSceneDIContainer()
    let coordinator = InitialCoordinator(tabBarController: tabBar, dependencies: dependencies)
    
    self.window.rootViewController = tabBar
    self.window.makeKeyAndVisible()
    
    childCoordinators[.initial] = coordinator
    coordinator.delegate = self
    coordinator.start(with: .initialSceneIsRequired)
  }
  
  fileprivate func navigateToMainFlow() {
    let navigationVC = UINavigationController()
    
    let dependencies = appDIContainer.makeMainSceneDIContainer()
    let coordinator = MainCoordinator(navigationController: navigationVC, dependencies: dependencies)
    
    self.window.rootViewController = navigationVC
    self.window.makeKeyAndVisible()
    
    childCoordinators[.main] = coordinator
    coordinator.delegate = self
    coordinator.start(with: .mainSceneIsRequired)
  }
}

// MARK: - InitialCoordinatorDelegate

extension AppCoordinator: InitialCoordinatorDelegate {
  
  func initialCoordinatorDidFinish() {
    childCoordinators[.initial] = nil
    navigate(to: .mainSceneIsRequired)
  }
}

// MARK: - MainCoordinatorDelegate

extension AppCoordinator: MainCoordinatorDelegate {
  
  func mainCoordinatorDidFinish() {
    childCoordinators[.main] = nil
  }
}
