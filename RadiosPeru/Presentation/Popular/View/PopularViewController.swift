//
//  PopularViewController.swift
//  RadiosPeru
//
//  Created by Jeans on 10/18/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private let reuseIdentifier = "PopularViewCell"

class PopularViewController: UIViewController {
  
  var viewModel: PopularViewModel!
  
  var customView: GenericCollectionView!
  
  let interactor = Interactor()
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: PopularViewModel) -> PopularViewController {
    let controller = PopularViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    setupView()
    setupCollection()
    setupBindables()
  }
  
  func setupCollectionView() {
    customView = GenericCollectionView(frame: view.frame, layout: UICollectionViewFlowLayout() )
    view = customView
  }
  
  func setupView() {
    customView.collectionView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
  }
  
  func setupCollection() {
    let nibName = UINib(nibName: "PopularViewCell", bundle: nil)
    customView.collectionView.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func setupBindables() {
    
    let configureCollectionViewCell = configureCollectionViewDataSource()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionAiringToday>(configureCell: configureCollectionViewCell)
    
    viewModel.output
      .viewState
      .map { [SectionAiringToday(header: "Shows Today", items: $0.currentEntities) ] }
      .bind(to: customView.collectionView.rx.items(dataSource: dataSource) )
      .disposed(by: disposeBag)
    
    customView.collectionView.rx
      .modelSelected( PopularCellViewModel.self)
      .subscribe(onNext: { [weak self] item in
        guard let strongSelf = self else { return }
        strongSelf.viewModel.stationDidSelect(with: item.radioStation)
      })
      .disposed(by: disposeBag)
    
    customView.collectionView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.output
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.configView(with: state)
      })
      .disposed(by: disposeBag)
    
    viewModel?.getStations()
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
    guard let collectionView = customView.collectionView else { return }
    
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
    
    messageLabel.text = message
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.sizeToFit()
    
    collectionView.backgroundView = messageLabel
  }
  
  func restoreBackground() {
    customView.collectionView.backgroundView = nil
  }
}

// MARK: - Configure CollectionView Views

extension PopularViewController {
  
  func configureCollectionViewDataSource() -> (
    CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell ) {
      let configureCell: CollectionViewSectionedDataSource<SectionAiringToday>.ConfigureCell = { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: reuseIdentifier, for: indexPath) as! PopularViewCell
        cell.viewModel = item
        return cell
      }
      return (configureCell)
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PopularViewController: UICollectionViewDelegateFlowLayout {
  
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
