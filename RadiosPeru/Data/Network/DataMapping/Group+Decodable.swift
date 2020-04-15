//
//  Group+Decodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 1/23/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation

extension RPP: Decodable {
  private enum CodingKeys: String, CodingKey {
    case type
    case id
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.type = try container.decode(String.self, forKey: .type)
    self.id = try container.decode(String.self, forKey: .id)
  }
}

extension CRP: Decodable {
  private enum CodingKeys: String, CodingKey {
    case type
    case base = "base_url"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.type = try container.decode(String.self, forKey: .type)
    self.base = try container.decode(String.self, forKey: .base)
  }
}

extension Group: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case type
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let typeKey = try container.decode(String.self, forKey: .type)
    
    let typeValue = try decoder.singleValueContainer()
    
    if typeKey == "rpp" {
      self = .rpp( try typeValue.decode(RPP.self) )
    } else {
      self = .crp( try typeValue.decode(CRP.self) )
    }
  }
}
