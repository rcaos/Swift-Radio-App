//
//  InitialViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

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
