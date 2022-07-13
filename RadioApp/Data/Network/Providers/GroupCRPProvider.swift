//
//  GrupoCRPProvider.swift
//  RadiosPeru
//
//  Created by Jeans on 10/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum GroupCRPProvider {
  
  case getNowShowDetail(String)
  
}

// MARK: - EndPoint

extension GroupCRPProvider: EndPoint {
  
  var baseURL: String {
    switch self {
    case .getNowShowDetail(let base) :
      return base
    }
  }
  
  var path: String {
    return "/programacion/get_parrilla"
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  var method: ServiceMethod {
    return .get
  }
  
}
