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
  
  private var cellsSubject = BehaviorSubject<[SectionModel<String, String>]>(value: [])
 
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
    cellsSubject.onNext( [
      SectionModel(model: "About",
                   items: [
                    "Send a message",
                    "Please Rate Radios Perú",
                    "Privacy Policy",
                    "Version"])] )
  }
}

extension SettingsViewModel {
  
  struct Input {}
  
  struct Output {
    let cells: Observable<[SectionModel<String, String>]>
  }
}
