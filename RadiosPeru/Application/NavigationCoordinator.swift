//
//  NavigationCoordinator.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/13/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public protocol NavigationCoordinator: Coordinator {
  
  var navigationController: UINavigationController { get }
  
}
