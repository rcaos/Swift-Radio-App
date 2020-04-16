//
//  FavoritesViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private let reuseIdentifier = "FavoriteTableViewCell"

class FavoritesViewController: UIViewController {
  
  var viewModel: FavoritesViewModel!
  
  var genericTableView: GenericTableView!
  
  var messageView = MessageView(frame: .zero)
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: FavoritesViewModel) -> FavoritesViewController {
    let controller = FavoritesViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Initializers
  
  override func loadView() {
    setupTableView()
    setupEmptyView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewModel()
    
    viewModel.getStations()
  }
  
  func setupTableView() {
    let nibName = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
    
    genericTableView = GenericTableView(frame: .zero)
    
    genericTableView.tableView.register(nibName, forCellReuseIdentifier: reuseIdentifier)
    genericTableView.tableView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
    
    self.view = genericTableView
  }
  
  // MARK: - Reactive
  
  private func setupViewModel() {
    
    genericTableView.tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.output.viewState
      .map { $0.currentEntities }
      .bind(to: genericTableView.tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: FavoriteTableViewCell.self)) { (_, element, cell) in
        cell.viewModel = element
        cell.delegate = self
    }
    .disposed(by: disposeBag)
    
    viewModel.output.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
    
    Observable
      .zip( genericTableView.tableView.rx.itemSelected,
            genericTableView.tableView.rx.modelSelected(FavoriteTableViewModel.self) )
      .bind { [weak self] (indexPath, cell) in
        guard let strongSelf = self else { return }
        strongSelf.genericTableView.tableView.deselectRow(at: indexPath, animated: true)
        strongSelf.viewModel.stationDidSelected(with: cell.radioStation)
    }
    .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<FavoriteTableViewModel>) {
    switch state {
    case .populated :
      messageView.isHidden = true
    default :
      messageView.isHidden = false
    }
  }
  
  func setupEmptyView() {
    messageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
    messageView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
    messageView.messageLabel.textColor = .white
    messageView.messageLabel.text = "There are no Stations added to your Favorites"
    
    messageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(messageView)
    
    NSLayoutConstraint.activate([
      messageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
      messageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
      messageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 8),
      messageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 8)
    ])
  }
}

extension FavoritesViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
}

extension FavoritesViewController: FavoriteTableViewCellDelegate {
  
  func favoriteIsPicked(for station: StationRemote) {
    viewModel.favoriteDidSelect(for: station)
  }
}
