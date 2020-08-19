//
//  SettingsRootView.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 8/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsRootView: UIView {
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading from a nib file its unsupported")
  }
  
  var messageView = MessageView(frame: .zero)
  
  let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.registerCell(cellType: UITableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.backgroundColor = .black
    tableView.tableFooterView = UIView()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    tableView.contentInsetAdjustmentBehavior = .automatic
    
    let font = Font.proximaNova.of(type: .bold, with: .normal)
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = font
    
    return tableView
  }()
  
  let disposeBag = DisposeBag()
  
  let viewModel: SettingsViewModelProtocol
  
  // MARK: - Initializer
  
  init(frame: CGRect = .zero, viewModel: SettingsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    
    addSubview(tableView)
    
    bind(to: viewModel)
  }
  
  fileprivate func bind(to viewModel: SettingsViewModelProtocol) {
    let dataSource = setDataSource()
    
    viewModel.cells
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    Observable.zip( tableView.rx.itemSelected,
                    tableView.rx.modelSelected(SettingsSectionModel.Item.self))
      .subscribe(onNext: { [weak self] (indexPath, element) in
        self?.tableView.deselectRow(at: indexPath, animated: true)
        self?.viewModel.didSelected(at: element)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func setDataSource() -> RxTableViewSectionedReloadDataSource<SettingsSectionModel> {
    return RxTableViewSectionedReloadDataSource<SettingsSectionModel>(
      configureCell: { (_, tableView, indexPath, element) in
        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(element)"
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = Font.proximaNova.of(type: .regular, with: .normal)
        
        if element.hasDisclosure {
          let chevronImageView = UIImageView(image: UIImage(named: "CollapsibleArrow"))
          chevronImageView.image = chevronImageView.image?.withRenderingMode(.alwaysTemplate)
          chevronImageView.tintColor = .white
          cell.accessoryView = chevronImageView
        }
        return cell
    },
      titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    }
    )
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds
  }
}
