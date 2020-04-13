//
//  StationRemote+Decodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension StationRemote: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case name
    case image
    case city
    case frecuency
    case slogan
    case urlStream
    case pathImage = "path_image"
    case group
  }
  
  // MARK: - Initializer
  
  public init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.name = try container.decode(String.self, forKey: .name)
    
    self.city = try container.decode(String.self, forKey: .city)
    self.frecuency = try container.decode(String.self, forKey: .frecuency)
    self.slogan = try container.decode(String.self, forKey: .slogan)
    self.urlStream = try container.decode(String.self, forKey: .urlStream)
    self.pathImage = try container.decode(String.self, forKey: .pathImage)
    
    let customGroup = try container.decode(Group.self, forKey: .group)
    switch customGroup {
    case .rpp(let rpp):
      self.group = rpp.type
      self.groupId = rpp.id
      self.groupBase = ""
    case .crp(let crp):
      self.group = crp.type
      self.groupId = ""
      self.groupBase = crp.base
    case .unknown:
      self.group = ""
      self.groupId = ""
      self.groupBase = ""
    }
  }
}
