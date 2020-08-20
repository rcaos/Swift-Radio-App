//
//  PopularViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class PopularViewController: NiblessViewController {
  
  let viewModel: PopularViewModelProtocol
  
  init(viewModel: PopularViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
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
