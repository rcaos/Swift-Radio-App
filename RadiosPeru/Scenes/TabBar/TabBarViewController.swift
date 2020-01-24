//
//  TabBarViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var popularViewModel: PopularViewModel?
    
    var favoriteViewModel: FavoritesViewModel?
    
    var radioDelegate: MainControllerDelegate?
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = createViewControllers()
    }
    
    private func createViewControllers() -> [UIViewController] {
        let popularVC = PopularViewController()
        popularVC.viewModel = popularViewModel
        popularVC.delegate = radioDelegate
        popularVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.viewModel = favoriteViewModel
        favoritesVC.delegate = radioDelegate
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return [popularVC, favoritesVC]
    }
}
