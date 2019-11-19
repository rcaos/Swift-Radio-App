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
        
        configureViewControllers()
        
        tabBar.barTintColor = UIColor(red:55/255, green:55/255, blue:55/255, alpha:1.0)
        tabBar.tintColor = UIColor.white
    }
    
    private func configureViewControllers() {
        if let viewControllers = viewControllers {
            for controller in viewControllers {
                if let destination = controller as? PopularViewController {
                    destination.viewModel = popularViewModel
                    destination.delegate = radioDelegate
                }
                
                if let destination = controller as? FavoritesViewController {
                    destination.viewModel = favoriteViewModel
                    destination.delegate = radioDelegate
                }
            }
        }
    }
}
