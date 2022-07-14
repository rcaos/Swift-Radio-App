//
//  RadioShow.swift
//  RadiosPeru
//
//  Created by Jeans on 10/28/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

public struct ShowRPP: Show {
  
  public var id: String
  public var name: String
  public var imageURL: String
  
  public var startTime: String
  public var endTime: String
}

extension ShowRPP {
  
  public var horario: String {
    return startTime + " - " + endTime
  }
}
