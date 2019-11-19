//
//  InitialNavigationController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/19/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class InitialNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red:55/255, green:55/255, blue:55/255, alpha:1.0)
        navigationBar.prefersLargeTitles = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}
