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

class MainViewControler: UIViewController, StoryboardInstantiable {
    
    private var viewModel: MainViewModel!
    private var controllersFactory: MainViewControllersFactory!
    
    let interactor = Interactor()
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var miniPlayerView: UIView!
    
    var tabBarVC: UITabBarController!
    var miniPlayerVC: MiniPlayerViewController!
    
    static func create(with viewModel: MainViewModel, controllersFactory: MainViewControllersFactory) -> MainViewControler {
        let controller = MainViewControler.instantiateViewController()
        controller.viewModel = viewModel
        controller.controllersFactory = controllersFactory
        
        return controller
    }
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        navigationItem.title = "Radios Perú"
        
        setupTabBarView()
        setupMiniPlayerView()
    }
    
    private func setupMiniPlayerView() {
        miniPlayerVC = MiniPlayerViewController.create(with: viewModel.miniPlayer)
        miniPlayerVC.delegate = self
        miniPlayerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        miniPlayerView.addSubview( miniPlayerVC.view )
        
        NSLayoutConstraint.activate([miniPlayerVC.view.topAnchor.constraint(equalTo: miniPlayerView.topAnchor),
                                     miniPlayerVC.view.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor),
                                     miniPlayerVC.view.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor),
                                     miniPlayerVC.view.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor)])
    }
    
    private func setupTabBarView() {
        tabBarVC = UITabBarController()
        tabBarVC.viewControllers = buildViewControllers()
        
        tabBarVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        tabBarView.addSubview( tabBarVC.view )
        NSLayoutConstraint.activate([tabBarVC.view.topAnchor.constraint(equalTo: tabBarView.topAnchor),
                                     tabBarVC.view.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
                                     tabBarVC.view.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
                                     tabBarVC.view.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor)])
    }
    
    private func buildViewControllers() -> [UIViewController] {
        
        guard let popularVC = controllersFactory.makePopularViewController() as? PopularViewController else { return [] }
        popularVC.delegate = self
        popularVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
//        let favoritesVC = FavoritesViewController()
//        favoritesVC.viewModel = viewModel.buildFavoriteViewModel()
//        favoritesVC.delegate = self
//        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return [popularVC]
        //return [popularVC, favoritesVC]
    }
}

extension MainViewControler : MiniPlayerControllerDelegate  {
    
    func miniPlayerController(_ miniPlayerViewController: MiniPlayerViewController, didSelectRadio radio: PlayerViewModel) {
        
        // MARK: - TODO, esto debe ir en una extension, controlado.
        // Handle navigation
        let playerVC = PlayerViewController.create(with: radio)
        playerVC.transitioningDelegate = self
        playerVC.interactor = interactor
        
        present(playerVC, animated: true, completion: nil)
        
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

// MARK: - MainViewControllersFactory

protocol MainViewControllersFactory {
    
    func makePopularViewController() -> UIViewController
    
}
