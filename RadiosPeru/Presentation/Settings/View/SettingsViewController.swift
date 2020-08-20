//
//  SettingsViewController.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class SettingsViewController: NiblessViewController {
  
  let viewModel: SettingsViewModelProtocol
  
  init(viewModel: SettingsViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - Life Cycle
  
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
