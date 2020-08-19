//
//  SettingsViewController.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  var viewModel: SettingsViewModelProtocol!
  
  static func create(with viewModel: SettingsViewModelProtocol) -> SettingsViewController {
    let controller = SettingsViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Initializer
  
  override func loadView() {
    view = SettingsRootView(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
}
