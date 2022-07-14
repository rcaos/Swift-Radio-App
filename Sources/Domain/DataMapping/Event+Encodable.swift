//
//  Event+Encodable.swift
//  RadiosPeru
//
//  Created by Jeans Ruiz on 4/29/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

extension Event: Encodable {

  private enum CodingKeys: String, CodingKey {
    case radioId
    case radioName
    case urlStream
    case description
    case date
    case uuid
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(radioId, forKey: .radioId)
    try container.encode(radioName, forKey: .radioName)
    try container.encode(urlStream, forKey: .urlStream)
    try container.encode(description, forKey: .description)
    try container.encode(date, forKey: .date)
    try container.encode(uuid, forKey: .uuid)
  }
}
