//
//  MainViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit

protocol MainControllerDelegate: class {
    
    func mainControllerDelegate(_ miniPlayerViewController: UIViewController, didConfigRadio name: String, group: String)
    
}

class MainViewControler: UIViewController {
    
    var viewModel = MainViewModel()
    
    let interactor = Interactor()
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "playerSegue",
            let destination = segue.destination as? PlayerViewController,
            let model = sender as? PlayerViewModel {
            let _ = destination.view
            destination.viewModel = model
            destination.transitioningDelegate = self
            destination.interactor = interactor
        }
        
        if segue.identifier == "tabBarSegue",
            let destination = segue.destination as? TabBarViewController {
            destination.popularViewModel = viewModel.buildPopularViewModel()
            destination.favoriteViewModel = viewModel.buildFavoriteViewModel()
            destination.radioDelegate = self
        }
        
        if segue.identifier == "miniPlayerSegue",
            let destination = segue.destination as? MiniPlayerViewController {
            let _ = destination.view
            destination.delegate = self
            destination.viewModel = viewModel.miniPlayer
        }
    }
}

extension MainViewControler : MiniPlayerControllerDelegate  {
    
    func miniPlayerController(_ miniPlayerViewController: MiniPlayerViewController, didSelectRadio radio: PlayerViewModel) {
        performSegue(withIdentifier: "playerSegue", sender: radio)
    }
}

extension MainViewControler: MainControllerDelegate {
    
    func mainControllerDelegate(_ miniPlayerViewController: UIViewController, didConfigRadio name: String, group: String) {
        viewModel.selectStation(by: name, group: group)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainViewControler: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

