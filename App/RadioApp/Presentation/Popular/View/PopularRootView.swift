//
//  PopularRootView.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

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
  
  let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: PopularViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(collectionView)
    bind(to: viewModel)
  }
  
  fileprivate func bind(to viewModel: PopularViewModelProtocol) {
    let configureCollectionViewCell = configureCollectionViewDataSource()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionAiringToday>(configureCell: configureCollectionViewCell)
    
    viewModel.viewState
      .map { [SectionAiringToday(header: "Shows Today", items: $0.currentEntities) ] }
      .bind(to: collectionView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected( PopularCellViewModel.self)
      .subscribe(onNext: { [weak self] item in
        guard let strongSelf = self else { return }
        strongSelf.viewModel.stationDidSelect(with: item.radioStation)
      })
      .disposed(by: disposeBag)
    
    collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  func configView(with state: SimpleViewState<PopularCellViewModel>) {
    switch state {
    case .populated :
      restoreBackground()
    case .empty :
      setBackground("There are no Stations to Show")
    default:
      break
    }
  }
  
  func setBackground(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
    
    messageLabel.text = message
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.sizeToFit()
    
    collectionView.backgroundView = messageLabel
  }
  
  func restoreBackground() {
    collectionView.backgroundView = nil
  }
  
  fileprivate func configureCollectionViewDataSource() -> (
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell ) {
      let configureCell: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell = { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PopularViewCell.dequeuIdentifier, for: indexPath) as! PopularViewCell
        cell.viewModel = item
        return cell
      }
      return (configureCell)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = bounds
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularRootView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  //Espacio entre Row y Row
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  //Espacio entre Cells consecutivas
  //Equivale a "flow.minimumInteritemSpacing"
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let numberOfRows = CGFloat(3.0)
    
    //Tener en cuenta el espacio entre Cells
    //Por ejemplo 3 cells:
    //          10                 10
    // cell#1 - space -  cell#2 - space - cell#3
    
    let width = collectionView.frame.width / numberOfRows
    
    return CGSize(width: width, height: width)
  }
}
