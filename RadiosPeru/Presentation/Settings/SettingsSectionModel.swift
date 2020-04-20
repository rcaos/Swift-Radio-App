//
//  SettingsSectionModel.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxDataSources

public enum SettingsType: CustomStringConvertible {
  
  case
  sendMessage(String),
  
  rateApp(String),
  
  privacyPolicy(String),
  
  version (String)
  
  var hasDisclosure: Bool {
    switch self {
    case .sendMessage, .rateApp, .privacyPolicy:
      return true
    case .version:
      return false
    }
  }
  
  // MARK: - TODO, internationalization
  
  public var description: String {
    switch self {
    case .sendMessage:
      return "Send a Message"
      
    case .rateApp:
      return "Please Rate Radios Perú"
      
    case .privacyPolicy:
      return "Privacy Policy"
      
    case .version(let versionNumber):
      return versionNumber
    }
  }
}

public struct SettingsSectionModel: SectionModelType {
  
  public var model: String
  
  public var items: [SettingsType]
  
  public init(model: String, items: [Item]) {
    self.model = model
    self.items = items
  }
  
  public typealias Identity = String
  public typealias Item = SettingsType
  
  public init(original: SettingsSectionModel, items: [SettingsType]) {
    self.model = original.model
    self.items = items
  }
}
