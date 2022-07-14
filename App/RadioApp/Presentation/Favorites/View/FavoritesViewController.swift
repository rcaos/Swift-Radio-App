//
//  FavoritesViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class FavoritesViewController: NiblessViewController {
  
  let viewModel: FavoritesViewModelProtocol
  
  init(viewModel: FavoritesViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
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
