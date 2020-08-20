//
//  FavoritesRootView.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesRootView: UIView {
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading from a nib file its unsupported")
  }
  
  var messageView = MessageView(frame: .zero)
  
  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerNib(cellType: FavoriteTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.backgroundColor = .black
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    tableView.contentInsetAdjustmentBehavior = .automatic
    return tableView
  }()
  
  let disposeBag = DisposeBag()
  
  let viewModel: FavoritesViewModelProtocol
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: FavoritesViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(tableView)
    setupEmptyView()
    
    bind(to: viewModel)
  }
  
  fileprivate func bind(to viewModel: FavoritesViewModelProtocol) {
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    let (cellIdentifier, cellType) = (FavoriteTableViewCell.dequeuIdentifier, FavoriteTableViewCell.self)
    
    viewModel.viewState
      .map { $0.currentEntities }
      .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { (_, element, cell) in
        cell.viewModel = element
        cell.delegate = self
    }
    .disposed(by: disposeBag)
    
    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
    
    Observable
      .zip( tableView.rx.itemSelected,
            tableView.rx.modelSelected(FavoriteTableViewModel.self) )
      .bind { [weak self] (indexPath, cell) in
        guard let strongSelf = self else { return }
        strongSelf.tableView.deselectRow(at: indexPath, animated: true)
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
  
  fileprivate func setupEmptyView() {
    messageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 200)
    messageView.backgroundColor = .black
    messageView.messageLabel.textColor = .white
    messageView.messageLabel.text = "There are no Stations added to your Favorites"
    
    messageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(messageView)
    
    NSLayoutConstraint.activate([
      messageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
      messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
    ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}

// MARK: - UITableViewDelegate

extension FavoritesRootView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
}

// MARK: - FavoriteTableViewCellDelegate

extension FavoritesRootView: FavoriteTableViewCellDelegate {
  
  func favoriteIsPicked(for station: StationProp) {
    viewModel.favoriteDidSelect(for: station)
  }
}
