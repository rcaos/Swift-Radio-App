//
//  InitialViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    private var viewModel = InitialViewModel()
    
    private var appDelegate: AppDelegate? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return delegate
    }
    
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
