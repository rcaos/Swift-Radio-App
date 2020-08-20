//
//  MainCoordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

// MARK: - TODO, separate files too

public protocol MainCoordinatorDelegate: class {
  func mainCoordinatorDidFinish()
}

public enum MainSteps: Step {
  case
  
  mainSceneIsRequired,
  
  mainSceneDidFinish,
  
  miniPlayerDidSelected(station: StationProp),
  
  settingsIsRequired
}

public protocol MainCoordinatorDependencies {
  
  func makeMainViewController(coordinator: MainCoordinatorProtocol?) -> MainViewControler
  
  func makeSettingsViewController() -> UIViewController
  
  func makePlayerViewController(with station: StationProp) -> PlayerViewController
}

public protocol MainCoordinatorProtocol: class {
  
  func navigate(to step: MainSteps)
}

public class MainCoordinator: NavigationCoordinator, MainCoordinatorProtocol {
  
  public var navigationController: UINavigationController
  
  weak var delegate: MainCoordinatorDelegate?
  
  private let dependencies: MainCoordinatorDependencies
  
  private var mainViewController: MainViewControler?
  
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
      
    case .miniPlayerDidSelected(let station):
      showPlayer(station: station)
      
    case .settingsIsRequired:
      showSettings()
    }
  }
  
  // MARK: - Build Scenes
  
  fileprivate func showMainScene() {
    let mainVC = dependencies.makeMainViewController(coordinator: self)
    mainVC.title = "Radios Perú"
    
    if mainViewController == nil {
      mainViewController = mainVC
    }
    navigationController.setViewControllers([mainVC], animated: true)
  }
  
  fileprivate func showPlayer(station: StationProp) {
    
    let playerController = dependencies.makePlayerViewController(with: station)
    
    if #available(iOS 13, *) {
    } else {
      playerController.transitioningDelegate = mainViewController
      playerController.interactor = mainViewController?.interactor
    }
    
    navigationController.present(playerController, animated: true, completion: nil)
  }
  
  fileprivate func showSettings() {
    let settingsVC = dependencies.makeSettingsViewController()
    navigationController.pushViewController(settingsVC, animated: true)
  }
}
