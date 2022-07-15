//
//  PopularRootView.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift

enum SecionPopularStationsView: Hashable {
  case list
}

class PopularRootView: UIView {
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading from a nib file its unsupported")
  }
  
  let viewModel: PopularViewModelProtocol!
  
  var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .black
    collectionView.registerNib(cellType: PopularViewCell.self)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    return collectionView
  }()

  typealias DataSource = UICollectionViewDiffableDataSource<SecionPopularStationsView, PopularCellViewModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SecionPopularStationsView, PopularCellViewModel>
  private var dataSource: DataSource?

  let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: PopularViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(collectionView)
    bind(to: viewModel)
  }
  
  fileprivate func bind(to viewModel: PopularViewModelProtocol) {
    collectionView.delegate = self

    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, viewModel in
      let cell = collectionView.dequeueReusableCell(with: PopularViewCell.self, for: indexPath)
      cell.setupUI(with: viewModel)
      return cell
    }

    viewModel
      .viewState
      .map { $0.currentEntities }
      .map { entities -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(entities, toSection: .list)
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)

    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  private func configView(with state: SimpleViewState<PopularCellViewModel>) {
    switch state {
    case .populated :
      restoreBackground()
    case .empty :
      setBackground("There are no Stations to Show")
    default:
      break
    }
  }
  
  private func setBackground(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
    
    messageLabel.text = message
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.sizeToFit()
    
    collectionView.backgroundView = messageLabel
  }

  private func restoreBackground() {
    collectionView.backgroundView = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularRootView: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.stationDidSelect(index: indexPath.row)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  // Espacio entre Row y Row
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  // Espacio entre Cells consecutivas
  // Equivale a "flow.minimumInteritemSpacing"
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let numberOfRows = CGFloat(3.0)
    
    // Tener en cuenta el espacio entre Cells
    // Por ejemplo 3 cells:
    //          10                 10
    // cell#1 - space -  cell#2 - space - cell#3

    let width = collectionView.frame.width / numberOfRows

    return CGSize(width: width, height: width)
  }
}
