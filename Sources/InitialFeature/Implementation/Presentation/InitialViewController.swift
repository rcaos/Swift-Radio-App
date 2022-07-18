import UIKit

class InitialViewController: UIViewController {
  
  var viewModel: InitialViewModelProtocol!
  
  static func create(with viewModel: InitialViewModelProtocol) -> InitialViewController {
    let controller = InitialViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
}
