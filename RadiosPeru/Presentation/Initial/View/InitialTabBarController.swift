//
//  InitialTabBarController.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class InitialTabBarController: UITabBarController {
    
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
        
        self.viewControllers = createControllers()
    }
    
    private func createControllers() -> [UIViewController] {
        let initialVC = appDIContainer.makeInitialSceneDIContainer().makeInitialViewController()
        
        let initialNavigation = UINavigationController(rootViewController: initialVC)
        
        return [initialNavigation]
    }
}
