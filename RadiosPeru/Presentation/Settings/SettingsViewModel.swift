//
//  SettingsViewModel.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources

final class SettingsViewModel {
  
  private var cellsSubject = BehaviorSubject<[SettingsSectionModel]>(value: [])
  
  private let disposeBag = DisposeBag()
  
  public let input: Input
  
  public let output: Output
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output(cells: cellsSubject.asObservable())
  }
  
  // MARK: - Public Methods
  
  func viewDidLoad() {
    
    let firstSection = SettingsSectionModel(
      model: "settings.about".localized(),
      items: [
        .sendMessage("jeansruiz.c@gmail.com"),
        .rateApp("https://github.com/rcaos"),
        .privacyPolicy("https://github.com/rcaos")
    ])
    
    let secondSection = SettingsSectionModel(
      model: "settings.version".localized(),
      items: [
        .version( getVersionBuildDescription() )
    ])
    
    cellsSubject.onNext( [firstSection, secondSection])
  }
  
  public func didSelected(at element: SettingsSectionModel.Item) {
    
    switch element {
    case .sendMessage(let email):
      sendMessage(to: email)
    case .privacyPolicy(let url):
      open(url: url)
    case .rateApp(let urlApp):
      open(url: urlApp)
    default:
      break
    }
  }
  
  // MARK: - Private
  
  fileprivate func sendMessage(to email: String) {
    let app = UIApplication.shared
    
    guard let urlAppEmail = URL(string: "mailto:\(email)"),
      app.canOpenURL(urlAppEmail) else { return }
    app.open(urlAppEmail, options: [:], completionHandler: nil)
  }
  
  fileprivate func open(url: String) {
    let app = UIApplication.shared
    
    guard let url = URL(string: url), app.canOpenURL(url) else { return }
    app.open(url, options: [:], completionHandler: nil)
  }
  
  fileprivate func getVersionBuildDescription() -> String {
    let nameApp: String = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    let releaseVersionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let buildVersionNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    return "\(nameApp) \(releaseVersionNumber) (\(buildVersionNumber))"
  }
}

extension SettingsViewModel {
  
  struct Input {}
  
  struct Output {
    let cells: Observable<[SettingsSectionModel]>
  }
}
