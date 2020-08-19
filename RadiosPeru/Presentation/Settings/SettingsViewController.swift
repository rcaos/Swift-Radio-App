//
//  SettingsViewController.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

private let reuseIdentifier = "SettingsTableViewCell"

class SettingsViewController: UIViewController {
  
  var viewModel: SettingsViewModel!
  
  var genericTableView: GenericTableView!
  
  let disposeBag = DisposeBag()
  
  static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
    let controller = SettingsViewController()
    controller.viewModel = viewModel
    return controller
  }
  
  // MARK: - Initializers
  
  override func loadView() {
    setupTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewModel()
    viewModel.viewDidLoad()
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  func setupTableView() {
    genericTableView = GenericTableView(frame: .zero)
    
    genericTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    genericTableView.tableView.backgroundColor = .black
    genericTableView.tableView.rowHeight = UITableView.automaticDimension
    
    let font = Font.proximaNova.of(type: .bold, with: .normal)
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = font
    
    self.view = genericTableView
  }
  
  // MARK: - Reactive
  
  private func setupViewModel() {
    let dataSource = setDataSource()
    
    viewModel.output.cells
      .bind(to: genericTableView.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    Observable.zip( genericTableView.tableView.rx.itemSelected,
                    genericTableView.tableView.rx.modelSelected(SettingsSectionModel.Item.self))
      .subscribe(onNext: { [weak self] (indexPath, element) in
        self?.genericTableView.tableView.deselectRow(at: indexPath, animated: true)
        self?.viewModel.didSelected(at: element)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func setDataSource() -> RxTableViewSectionedReloadDataSource<SettingsSectionModel> {
    return RxTableViewSectionedReloadDataSource<SettingsSectionModel>(
      configureCell: { (_, tableView, _, element) in
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
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
}
