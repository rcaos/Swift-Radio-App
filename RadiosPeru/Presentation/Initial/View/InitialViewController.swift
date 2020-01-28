//
//  InitialViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    var viewModel: InitialViewModel!
    
    private var appDelegate: AppDelegate? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return delegate
    }
    
    static func create(with viewModel: InitialViewModel) -> InitialViewController {
        let controller = InitialViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindables()
        viewModel.getStations()
    }
    
    //MARK: - Reactive Behaviour
    
    private func setupBindables() {
        viewModel.stationsFetched = { [weak self] in
            self?.appDelegate?.initialTransition()
        }
    }
}
