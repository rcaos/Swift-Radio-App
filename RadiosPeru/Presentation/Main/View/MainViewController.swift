//
//  MainViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 11/5/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift

class MainViewControler: UIViewController, StoryboardInstantiable {
  
  private var viewModel: MainViewModel!
  private var controllersFactory: MainViewControllersFactory!
  
  let interactor = Interactor()
  
  @IBOutlet weak var tabBarView: UIView!
  @IBOutlet weak var miniPlayerView: UIView!
  
  var tabBarVC: UITabBarController!
  var miniPlayerVC: MiniPlayerViewController!
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: MainViewModel, controllersFactory: MainViewControllersFactory) -> MainViewControler {
    let controller = MainViewControler.instantiateViewController()
    controller.viewModel = viewModel
    controller.controllersFactory = controllersFactory
    
    return controller
  }
  
  // MARK: - Initializers
  
  override func viewDidLoad() {
    view.backgroundColor = .black
    title = "Radios Perú"
    
    setupTabBarView()
    setupMiniPlayerView()
    setupViewModel()
    setupSettingsButton()
  }
  
  func setupViewModel() {
    viewModel.route.bind {[weak self] routing in
      self?.handle(routing)
    }
  }
  
  private func setupMiniPlayerView() {
    miniPlayerVC = controllersFactory.makeMiniPlayerViewController(with: viewModel.miniPlayer, delegate: viewModel) as? MiniPlayerViewController
    miniPlayerVC.view.translatesAutoresizingMaskIntoConstraints = false
    
    miniPlayerView.addSubview( miniPlayerVC.view )
    
    NSLayoutConstraint.activate([miniPlayerVC.view.topAnchor.constraint(equalTo: miniPlayerView.topAnchor),
                                 miniPlayerVC.view.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor),
                                 miniPlayerVC.view.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor),
                                 miniPlayerVC.view.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor)])
  }
  
  private func setupSettingsButton() {
    let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .done, target: nil, action: nil)
    navigationItem.rightBarButtonItem = settingsButton
    navigationItem.rightBarButtonItem?.tintColor = .white
    
    settingsButton.rx
      .tap.bind { [weak self] in
        self?.viewModel.route.value = .showSettings
    }.disposed(by: disposeBag)
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
    
    guard let popularVC = controllersFactory.makePopularViewController(delegate: viewModel) as? PopularViewController else { return [] }
    popularVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "houseItem"), tag: 0)
    
    guard let favoritesVC = controllersFactory.makeFavoritesViewController(delegate: viewModel) as? FavoritesViewController else { return [] }
    favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    
    return [popularVC, favoritesVC]
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

// MARK: - Navigation

extension MainViewControler {
  
  func handle(_ route: MainViewModelRoute) {
    switch route {
    case .initial: break
      
    case .showPlayer(let station):
      guard let playerController =
        controllersFactory.makePlayerViewController(with: station) as? PlayerViewController else { break }
      
      if #available(iOS 13, *) {
      } else {
        playerController.transitioningDelegate = self
        playerController.interactor = interactor
      }
      
      present(playerController, animated: true, completion: nil)
      
    case .showSettings:
      
      let settingsVC = controllersFactory.makeSettingsViewController()
      settingsVC.title = "Settings"
      navigationController?.pushViewController(settingsVC, animated: true)
    }
    
  }
}

// MARK: - MainViewControllersFactory

protocol MainViewControllersFactory {
  
  func makePopularViewController(delegate: PopularViewModelDelegate) -> UIViewController
  
  func makeFavoritesViewController(delegate: FavoritesViewModelDelegate) -> UIViewController
  
  func makeMiniPlayerViewController(with viewModel: MiniPlayerViewModel, delegate: MiniPlayerViewModelDelegate) -> UIViewController
  
  func makePlayerViewController(with station: StationRemote) -> UIViewController
  
  func makeSettingsViewController() -> UIViewController
}
