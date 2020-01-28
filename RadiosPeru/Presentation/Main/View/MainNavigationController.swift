//
//  MainNavigationController.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/24/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = createViewControllers()
    }
    
    private func createViewControllers() -> [UIViewController] {
        let topVC = appDIContainer.makeMainSceneDIContainer().makeMainViewController()
        return [topVC]
    }
}
