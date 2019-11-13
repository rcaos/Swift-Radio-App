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
    }
    
    private func configureViewControllers() {
        if let viewControllers = viewControllers {
            for controller in viewControllers {
                
                if let navigation = controller as? UINavigationController ,
                    let destination = navigation.topViewController as? PopularViewController{
                    destination.viewModel = popularViewModel
                    destination.delegate = radioDelegate
                }
                
                if let navigation = controller as? UINavigationController,
                    let destination =  navigation.topViewController as? FavoritesViewController {
                    destination.viewModel = favoriteViewModel
                    destination.delegate = radioDelegate
                }
                
            }
        }
    }
}
