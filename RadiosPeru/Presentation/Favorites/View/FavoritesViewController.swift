//
//  FavoritesViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  
  var viewModel: FavoritesViewModelProtocol!
  
  static func create(with viewModel: FavoritesViewModelProtocol) -> FavoritesViewController {
    let controller = FavoritesViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    view = FavoritesRootView(viewModel: viewModel)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
  }
}
