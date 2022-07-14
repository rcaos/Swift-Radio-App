//
//  MainViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift

public class MainViewControler: UIViewController, StoryboardInstantiable {
  
  private var viewModel: MainViewModelProtocol!
  
  private var controllersFactory: MainViewControllersFactory!

  public let interactor = Interactor()
  
  @IBOutlet weak var tabBarView: UIView!
  @IBOutlet weak var miniPlayerView: UIView!
  
  private var tabBarVC: UITabBarController!
  private var miniPlayerVC: UIViewController!
  
  private let disposeBag = DisposeBag()
  
  static func create(with viewModel: MainViewModelProtocol, controllersFactory: MainViewControllersFactory) -> MainViewControler {
    let controller = MainViewControler.instantiateViewController()
    controller.viewModel = viewModel
    controller.controllersFactory = controllersFactory
    
    return controller
  }
  
  // MARK: - Initializers
  
  override public func viewDidLoad() {
    view.backgroundColor = .black
    setupTabBarView()
    setupMiniPlayerView()
    setupViewModel()
  }
  
  fileprivate func setupTabBarView() {
    tabBarVC = UITabBarController()
    tabBarVC.viewControllers = buildViewControllers()
    
    tabBarVC.view.translatesAutoresizingMaskIntoConstraints = false
    
    tabBarView.addSubview( tabBarVC.view )
    NSLayoutConstraint.activate([tabBarVC.view.topAnchor.constraint(equalTo: tabBarView.topAnchor),
                                 tabBarVC.view.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
                                 tabBarVC.view.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
                                 tabBarVC.view.bottomAnchor.constraint(equalTo: tabBarView.bottomAnchor)])
  }
  
  fileprivate func setupMiniPlayerView() {
    miniPlayerVC = controllersFactory.makeMiniPlayerViewController()
    miniPlayerVC.view.translatesAutoresizingMaskIntoConstraints = false
    
    miniPlayerView.addSubview( miniPlayerVC.view )
    
    NSLayoutConstraint.activate([miniPlayerVC.view.topAnchor.constraint(equalTo: miniPlayerView.topAnchor),
                                 miniPlayerVC.view.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor),
                                 miniPlayerVC.view.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor),
                                 miniPlayerVC.view.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor)])
    miniPlayerView.isHidden = true
  }
  
  fileprivate func setupViewModel() {
    viewModel.showMiniPlayer = { [weak self] in
      guard let strongSelf = self else { return }
      UIView.transition(with: strongSelf.miniPlayerView, duration: 0.5, options: .transitionCrossDissolve, animations: {
        strongSelf.miniPlayerView.isHidden = false
      })
    }
  }

  fileprivate func buildViewControllers() -> [UIViewController] {
    let popularVC = controllersFactory.makePopularViewController()
    popularVC.tabBarItem = UITabBarItem(title: "home".localized(), image: UIImage(named: "houseItem"), tag: 0)
    
    let favoritesVC = controllersFactory.makeFavoritesViewController()
    favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    favoritesVC.tabBarItem.title = "favorites".localized()
    
    return [popularVC, favoritesVC]
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension MainViewControler: UIViewControllerTransitioningDelegate {
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissAnimator()
  }
  
  public  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}

// MARK: - MainViewControllersFactory

protocol MainViewControllersFactory {
  
  func makePopularViewController() -> UIViewController
  
  func makeFavoritesViewController() -> UIViewController
  
  func makeMiniPlayerViewController() -> UIViewController
}
