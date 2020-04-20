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
  
  func setupTableView() {
    genericTableView = GenericTableView(frame: .zero)
    
    genericTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    genericTableView.tableView.backgroundColor = .black
    
    let font = Font.proximaNova.of(type: .bold, with: .normal)
    UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = font
    
    self.view = genericTableView
  }
  
  // MARK: - Reactive
  
  private func setupViewModel() {
    
    genericTableView.tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
      configureCell: { (_, tableView, indexPath, element) in
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        cell.textLabel?.text = "\(element)"
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = Font.proximaNova.of(type: .regular, with: .normal)
        
        if indexPath.row != 3 {
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
    
    viewModel.output.cells
      .bind(to: genericTableView.tableView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
    
    genericTableView.tableView.rx
      .itemSelected
      .bind { [weak self] indexPath in
        self?.genericTableView.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 2,
          let url = URL(string: "https://sites.google.com/view/youngradioplus/supports") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }.disposed(by: disposeBag)
  }
 
}

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
}
