import UIKit
import Shared

public protocol InitialCoordinatorProtocol: AnyObject {
  func navigate(to step: InitialStep)
}

public protocol InitialCoordinatorDelegate: AnyObject {
  func initialCoordinatorDidFinish()
}

public enum InitialStep: Step {
  case initialSceneIsRequired
  case initialSceneDidFinish
}

public protocol InitialCoordinatorDependencies {
  func buildInitialViewController(coordinator: InitialCoordinatorProtocol?) -> UIViewController
}
