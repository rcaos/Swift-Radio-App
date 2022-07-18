import UIKit
import Shared

public class InitialCoordinator: Coordinator, InitialCoordinatorProtocol {
  public weak var delegate: InitialCoordinatorDelegate?
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
