//
//  PopularViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {
  
  var viewModel: PopularViewModelProtocol!
  
  static func create(with viewModel: PopularViewModelProtocol) -> PopularViewController {
    let controller = PopularViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    view = PopularRootView(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
}
